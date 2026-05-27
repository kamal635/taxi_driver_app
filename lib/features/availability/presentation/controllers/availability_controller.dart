import 'dart:async' show StreamSubscription, unawaited;

import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';
import 'package:bawabat_al_saeq/features/availability/domain/failures/availability_runtime_failure.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/state/availability_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availabilityProvider =
    NotifierProvider<AvailabilityController, AvailabilityState>(
      AvailabilityController.new,
    );

/// Orchestrates the driver online/offline flow.
///
/// The backend remains the source of truth for business availability, while
/// this controller coordinates local runtime services, location readiness, and
/// small UI state flags.
final class AvailabilityController extends Notifier<AvailabilityState> {
  StreamSubscription<LocationFailureReason>? _locationFailuresSubscription;
  StreamSubscription<DriverBackgroundServiceEvent>? _serviceEventsSubscription;

  bool _isAutoStopping = false;
  bool _isReconciling = false;

  @override
  AvailabilityState build() {
    final serviceBridge = ref.read(driverBackgroundServiceBridgeProvider);

    _serviceEventsSubscription ??= serviceBridge.serviceEvents.listen(
      _handleNativeServiceEvent,
    );

    ref.onDispose(() {
      unawaited(_locationFailuresSubscription?.cancel());
      unawaited(_serviceEventsSubscription?.cancel());

      _locationFailuresSubscription = null;
      _serviceEventsSubscription = null;
    });

    unawaited(reconcileAvailabilityOnAppStartOrResume());

    return const AvailabilityState.initial();
  }

  /// Main entry point for the online/offline toggle.
  Future<void> requestSetOnline({required bool value}) async {
    if (state.isBusy || state.isOnline == value) return;

    _setBusy(true);
    _clearLocationError();
    _clearServerError();

    try {
      if (value) {
        await _goOnline();
      } else {
        await _goOffline();
      }
    } finally {
      _setBusy(false);
    }
  }

  /// Used after accepting an offer.
  ///
  /// Stops local online runtime and updates local UI state only. It does not
  /// send OFFLINE to the backend because the driver is now busy with a trip.
  Future<void> stopRuntimeLocallyAfterAccept() async {
    _clearLocationError();
    _clearServerError();
    _markLocallyOffline();

    await _stopOnlineRuntimeSafely(context: 'after accept');
    await _stopTracking();
    await _saveOnlineIntent(false);
  }

  /// Reconciles availability after app launch or resume.
  Future<void> reconcileAvailabilityOnAppStartOrResume() async {
    if (_isReconciling) return;
    _isReconciling = true;

    try {
      final localDataSource = ref.read(availabilityLocalDataSourceProvider);
      final serviceBridge = ref.read(driverBackgroundServiceBridgeProvider);
      final locationTracker = ref.read(locationTrackerProvider);

      final onlineRequested = await localDataSource.getOnlineRequested();
      final isServiceRunning = await serviceBridge.isServiceRunning();

      if (!onlineRequested) {
        _markLocallyOffline();
        return;
      }

      if (!isServiceRunning) {
        await _stopTracking();
        await _stopOnlineRuntimeSafely(context: 'during reconcile');
        await _saveOnlineIntent(false);
        _markLocallyOffline();
        return;
      }

      await locationTracker.start();
      _subscribeToLocationFailures(locationTracker);

      state = state.copyWith(
        isOnline: true,
        locationError: null,
        serverError: null,
      );
    } finally {
      _isReconciling = false;
    }
  }

  /// Clears local runtime state without calling the backend.
  ///
  /// This is used for force logout/session cleanup flows.
  Future<void> forceLocalOfflineCleanup() async {
    _clearLocationError();
    _clearServerError();
    _markLocallyOffline();

    await _stopOnlineRuntimeSafely(context: 'force local cleanup');
    await _stopTracking();
    await _saveOnlineIntent(false);
  }

  void clearLocationError() => _clearLocationError();

  void clearServerError() => _clearServerError();

  void _handleNativeServiceEvent(DriverBackgroundServiceEvent event) {
    if (!state.isOnline || _isAutoStopping) return;

    unawaited(_handleUnexpectedServiceStop(event));
  }

  Future<void> _handleUnexpectedServiceStop(
    DriverBackgroundServiceEvent event,
  ) async {
    if (_isAutoStopping) return;
    _isAutoStopping = true;

    state = state.copyWith(
      isOnline: false,
      serverError: AvailabilityRuntimeFailure(
        reason: AvailabilityRuntimeFailureReason.backgroundServiceStopped,
        details: event.reason,
      ),
    );

    try {
      await _stopTracking();
      await _stopOnlineRuntimeSafely(context: 'unexpected native stop');
      await _saveOnlineIntent(false);
    } finally {
      _isAutoStopping = false;
    }
  }

  Future<void> _goOnline() async {
    final serviceBridge = ref.read(driverBackgroundServiceBridgeProvider);
    final startTracking = ref.read(startLocationTrackingUseCaseProvider);
    final locationTracker = ref.read(locationTrackerProvider);
    final setDriverStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtimeController = ref.read(driverRuntimeControllerProvider);

    final locationSettingsReady = await serviceBridge.ensureLocationSettings();

    if (!locationSettingsReady) {
      state = state.copyWith(
        isOnline: false,
        locationError: LocationFailureReason.serviceDisabled,
      );
      return;
    }

    final locationReadyResult = await startTracking();

    if (!locationReadyResult.isSuccess) {
      state = state.copyWith(
        isOnline: false,
        locationError:
            locationReadyResult.reason ??
            LocationFailureReason.unableToDetermine,
      );
      return;
    }

    try {
      await setDriverStatus(status: DriverStatus.online);
    } on Exception catch (error, stackTrace) {
      debugPrint('setStatus ONLINE failed: $error\n$stackTrace');

      await _stopTracking();

      state = state.copyWith(
        isOnline: false,
        serverError: error,
      );
      return;
    }

    try {
      await runtimeController.startOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint('startOnlineRuntime failed: $error\n$stackTrace');

      await _stopTracking();
      await _rollbackBackendOfflineAfterFailedOnlineStart();

      state = state.copyWith(
        isOnline: false,
        serverError: error,
      );
      return;
    }

    _subscribeToLocationFailures(locationTracker);
    await _saveOnlineIntent(true);

    state = state.copyWith(isOnline: true);
  }

  Future<void> _goOffline() async {
    final setDriverStatus = ref.read(setDriverStatusUseCaseProvider);

    _markLocallyOffline();
    await _stopOnlineRuntimeSafely(context: 'manual offline');
    await _stopTracking();

    try {
      await setDriverStatus(status: DriverStatus.offline);
    } on Exception catch (error, stackTrace) {
      debugPrint('setStatus OFFLINE failed: $error\n$stackTrace');
      state = state.copyWith(serverError: error);
    }

    await _saveOnlineIntent(false);
  }

  void _subscribeToLocationFailures(LocationTracker tracker) {
    if (_locationFailuresSubscription != null) return;

    _locationFailuresSubscription = tracker.failures.listen((reason) {
      if (!state.isOnline) return;
      unawaited(_forceOfflineBecauseOfLocationFailure(reason));
    });
  }

  Future<void> _forceOfflineBecauseOfLocationFailure(
    LocationFailureReason reason,
  ) async {
    if (_isAutoStopping) return;
    _isAutoStopping = true;

    state = state.copyWith(
      isOnline: false,
      locationError: reason,
    );

    try {
      await _stopTracking();
      await _stopOnlineRuntimeSafely(context: 'location failure');
      await _saveOnlineIntent(false);

      try {
        await ref.read(setDriverStatusUseCaseProvider)(
          status: DriverStatus.offline,
        );
      } on Exception catch (error, stackTrace) {
        debugPrint('setStatus OFFLINE (force) failed: $error\n$stackTrace');
        state = state.copyWith(serverError: error);
      }
    } finally {
      _isAutoStopping = false;
    }
  }

  Future<void> _rollbackBackendOfflineAfterFailedOnlineStart() async {
    try {
      await ref.read(setDriverStatusUseCaseProvider)(
        status: DriverStatus.offline,
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('rollback OFFLINE failed: $error\n$stackTrace');
    }
  }

  Future<void> _stopTracking() async {
    await _locationFailuresSubscription?.cancel();
    _locationFailuresSubscription = null;

    final stopTracking = ref.read(stopLocationTrackingUseCaseProvider);

    try {
      await stopTracking();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopTracking failed: $error\n$stackTrace');
    }
  }

  Future<void> _stopOnlineRuntimeSafely({required String context}) async {
    final runtimeController = ref.read(driverRuntimeControllerProvider);

    try {
      await runtimeController.stopOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopOnlineRuntime $context failed: $error\n$stackTrace');
    }
  }

  Future<void> _saveOnlineIntent(bool value) async {
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    try {
      await localDataSource.saveOnlineRequested(value: value);
    } on Exception catch (error, stackTrace) {
      debugPrint('saveOnlineRequested($value) failed: $error\n$stackTrace');
    }
  }

  void _markLocallyOffline() {
    state = state.copyWith(
      isOnline: false,
      isBusy: false,
      locationError: null,
      serverError: null,
    );
  }

  void _setBusy(bool value) {
    if (state.isBusy == value) return;
    state = state.copyWith(isBusy: value);
  }

  void _clearLocationError() {
    if (state.locationError == null) return;
    state = state.copyWith(locationError: null);
  }

  void _clearServerError() {
    if (state.serverError == null) return;
    state = state.copyWith(serverError: null);
  }
}
