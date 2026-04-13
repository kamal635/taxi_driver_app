import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/domain/entities/driver_status.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_providers.dart';
import 'package:taxi_driver_app/features/availability/presentation/state/availability_state.dart';

final availabilityProvider =
    NotifierProvider<AvailabilityController, AvailabilityState>(
      AvailabilityController.new,
    );

/// Orchestrates the driver online/offline flow without changing domain logic.
class AvailabilityController extends Notifier<AvailabilityState> {
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

    return const AvailabilityState(
      isOnline: false,
      isBusy: false,
    );
  }

  /// Main entry point for the online/offline toggle.
  Future<void> requestSetOnline({required bool value}) async {
    if (state.isBusy) return;

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
  /// Stops the local online runtime and updates local UI state only.
  /// Does NOT send OFFLINE status to the backend because
  ///  the driver is now Busy.
  Future<void> stopRuntimeLocallyAfterAccept() async {
    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    _clearLocationError();
    _clearServerError();

    state = state.copyWith(
      isOnline: false,
      isBusy: false,
      locationError: null,
      serverError: null,
    );

    try {
      await runtimeController.stopOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint(
        'stopOnlineRuntime after accept failed: $error\n$stackTrace',
      );
    }

    await _stopTracking();
    await localDataSource.saveOnlineRequested(value: false);
  }

  /// Reconciles availability after app launch or resume.
  Future<void> reconcileAvailabilityOnAppStartOrResume() async {
    if (_isReconciling) return;
    _isReconciling = true;

    try {
      final localDataSource = ref.read(availabilityLocalDataSourceProvider);
      final serviceBridge = ref.read(driverBackgroundServiceBridgeProvider);
      final runtimeController = ref.read(driverRuntimeControllerProvider);
      final locationTracker = ref.read(locationTrackerProvider);

      final onlineRequested = await localDataSource.getOnlineRequested();
      final isServiceRunning = await serviceBridge.isServiceRunning();

      if (!onlineRequested) {
        state = state.copyWith(
          isOnline: false,
          locationError: null,
          serverError: null,
        );
        return;
      }

      if (!isServiceRunning) {
        await _stopTracking();

        try {
          await runtimeController.stopOnlineRuntime();
        } on Exception catch (error, stackTrace) {
          debugPrint(
            'stopOnlineRuntime during reconcile failed: '
            '$error\n$stackTrace',
          );
        }

        await localDataSource.saveOnlineRequested(value: false);

        state = state.copyWith(
          isOnline: false,
          locationError: null,
          serverError: null,
        );
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

  Future<void> forceLocalOfflineCleanup() async {
    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    _clearLocationError();
    _clearServerError();

    state = state.copyWith(
      isOnline: false,
      isBusy: false,
      locationError: null,
      serverError: null,
    );

    try {
      await runtimeController.stopOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint(
        'forceLocalOfflineCleanup stop runtime failed: $error\n$stackTrace',
      );
    }

    await _stopTracking();
    await localDataSource.saveOnlineRequested(value: false);
  }

  void clearLocationError() => _clearLocationError();

  void clearServerError() => _clearServerError();

  void _handleNativeServiceEvent(DriverBackgroundServiceEvent event) {
    if (!state.isOnline || _isAutoStopping) return;

    _isAutoStopping = true;

    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    state = state.copyWith(
      isOnline: false,
      serverError: StateError(
        'Background driver service stopped: ${event.reason}',
      ),
    );

    unawaited(
      Future.wait([
        _stopTracking(),
        runtimeController.stopOnlineRuntime(),
        localDataSource.saveOnlineRequested(value: false),
      ]).whenComplete(() {
        _isAutoStopping = false;
      }),
    );
  }

  Future<void> _goOnline() async {
    final serviceBridge = ref.read(driverBackgroundServiceBridgeProvider);
    final startTracking = ref.read(startLocationTrackingUseCaseProvider);
    final locationTracker = ref.read(locationTrackerProvider);
    final setDriverStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

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

      try {
        await setDriverStatus(status: DriverStatus.offline);
      } on Exception catch (innerError, innerStackTrace) {
        debugPrint('rollback OFFLINE failed: $innerError\n$innerStackTrace');
      }

      state = state.copyWith(
        isOnline: false,
        serverError: error,
      );
      return;
    }

    _subscribeToLocationFailures(locationTracker);

    await localDataSource.saveOnlineRequested(value: true);

    state = state.copyWith(isOnline: true);
  }

  Future<void> _goOffline() async {
    final setDriverStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    state = state.copyWith(isOnline: false);

    try {
      await runtimeController.stopOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopOnlineRuntime failed: $error\n$stackTrace');
    }

    await _stopTracking();

    try {
      await setDriverStatus(status: DriverStatus.offline);
    } on Exception catch (error, stackTrace) {
      debugPrint('setStatus OFFLINE failed: $error\n$stackTrace');
      state = state.copyWith(serverError: error);
    }

    await localDataSource.saveOnlineRequested(value: false);
  }

  void _subscribeToLocationFailures(LocationTracker tracker) {
    if (_locationFailuresSubscription != null) return;

    _locationFailuresSubscription = tracker.failures.listen((reason) {
      if (!state.isOnline) return;
      _forceOffline(reason);
    });
  }

  void _forceOffline(LocationFailureReason reason) {
    if (_isAutoStopping) return;
    _isAutoStopping = true;

    final runtimeController = ref.read(driverRuntimeControllerProvider);
    final localDataSource = ref.read(availabilityLocalDataSourceProvider);

    state = state.copyWith(
      isOnline: false,
      locationError: reason,
    );

    unawaited(
      Future.wait([
        _stopTracking(),
        runtimeController.stopOnlineRuntime(),
        localDataSource.saveOnlineRequested(value: false),
      ]).whenComplete(() async {
        try {
          await ref.read(setDriverStatusUseCaseProvider)(
            status: DriverStatus.offline,
          );
        } on Exception catch (error, stackTrace) {
          debugPrint(
            'setStatus OFFLINE (force) failed: $error\n$stackTrace',
          );
          state = state.copyWith(serverError: error);
        } finally {
          _isAutoStopping = false;
        }
      }),
    );
  }

  Future<void> _stopTracking() async {
    await _locationFailuresSubscription?.cancel();
    _locationFailuresSubscription = null;

    final stopTracking = ref.read(stopLocationTrackingUseCaseProvider);

    try {
      await stopTracking();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopUseCase failed: $error\n$stackTrace');
    }
  }

  void _setBusy(bool value) {
    state = state.copyWith(isBusy: value);
  }

  void _clearLocationError() {
    state = state.copyWith(locationError: null);
  }

  void _clearServerError() {
    state = state.copyWith(serverError: null);
  }
}
