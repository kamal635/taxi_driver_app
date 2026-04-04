import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/local/availability_local_datasource.dart';
import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/driver_runtime_controller.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_tracking_providers.dart';

final availabilityProvider =
    NotifierProvider<AvailabilityController, AvailabilityState>(
      AvailabilityController.new,
    );

class AvailabilityController extends Notifier<AvailabilityState> {
  StreamSubscription<LocationFailureReason>? _failuresSub;
  StreamSubscription<DriverBackgroundServiceEvent>? _serviceEventsSub;

  bool _autoStopping = false;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  AvailabilityState build() {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _serviceEventsSub ??= bridge.serviceEvents.listen(
      _handleNativeServiceEvent,
    );

    ref.onDispose(() {
      unawaited(_failuresSub?.cancel());
      unawaited(_serviceEventsSub?.cancel());

      _failuresSub = null;
      _serviceEventsSub = null;
    });

    // Reconcile the real runtime state instead of blindly restoring local UI.
    unawaited(reconcileAvailabilityOnAppStartOrResume());

    return const AvailabilityState(
      isOnline: false,
      isBusy: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  // Main entry point for online/offline toggle.
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

  // Reconcile availability when app starts or resumes.
  Future<void> reconcileAvailabilityOnAppStartOrResume() async {
    final local = ref.read(availabilityLocalDatasourceProvider);
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);
    final runtime = ref.read(driverRuntimeControllerProvider);

    final requested = await local.getOnlineRequested();
    final serviceRunning = await bridge.isServiceRunning();

    if (!requested) {
      state = state.copyWith(
        isOnline: false,
        errorReason: null,
        serverError: null,
      );
      return;
    }

    if (!serviceRunning) {
      await _stopTracking();

      try {
        await runtime.stopOnlineRuntime();
      } on Exception catch (e, st) {
        debugPrint('stopOnlineRuntime during reconcile failed: $e\n$st');
      }

      await local.saveOnlineRequested(value: false);

      state = state.copyWith(
        isOnline: false,
        errorReason: null,
        serverError: null,
      );
      return;
    }

    _subscribeToFailures(ref.read(locationTrackerProvider));

    state = state.copyWith(
      isOnline: true,
      errorReason: null,
      serverError: null,
    );
  }

  void clearError() => _clearLocationError();

  void clearServerError() => _clearServerError();

  // ---------------------------------------------------------------------------
  // Native service events
  // ---------------------------------------------------------------------------

  // Handle stop events coming from the native Android service.
  void _handleNativeServiceEvent(DriverBackgroundServiceEvent event) {
    if (!state.isOnline) return;
    if (_autoStopping) return;

    _autoStopping = true;

    final runtime = ref.read(driverRuntimeControllerProvider);
    final local = ref.read(availabilityLocalDatasourceProvider);

    state = state.copyWith(
      isOnline: false,
      serverError: StateError(
        'Background driver service stopped: ${event.reason}',
      ),
    );

    unawaited(
      Future.wait([
        _stopTracking(),
        runtime.stopOnlineRuntime(),
        local.saveOnlineRequested(value: false),
      ]).whenComplete(() {
        _autoStopping = false;
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Online flow
  // ---------------------------------------------------------------------------

  // Full online flow:
  // permission -> tracking -> server -> runtime -> local state
  Future<void> _goOnline() async {
    final startTracking = ref.read(startLocationTrackingUseCaseProvider);
    final tracker = ref.read(locationTrackerProvider);
    final setStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtime = ref.read(driverRuntimeControllerProvider);
    final local = ref.read(availabilityLocalDatasourceProvider);

    // Step 1: ensure location is ready.
    final ready = await startTracking();

    if (!ready.isSuccess) {
      state = state.copyWith(
        isOnline: false,
        errorReason: ready.reason ?? LocationFailureReason.unableToDetermine,
      );
      return;
    }

    // Step 2: mark driver online on server.
    try {
      await setStatus(status: DriverStatus.online);
    } on Exception catch (e, st) {
      debugPrint('setStatus ONLINE failed: $e\n$st');

      await _stopTracking();

      state = state.copyWith(
        isOnline: false,
        serverError: e,
      );
      return;
    }

    // Step 3: start runtime services.
    try {
      await runtime.startOnlineRuntime();
    } on Exception catch (e, st) {
      debugPrint('startOnlineRuntime failed: $e\n$st');

      await _stopTracking();

      try {
        await setStatus(status: DriverStatus.offline);
      } on Exception catch (inner, innerSt) {
        debugPrint('rollback OFFLINE failed: $inner\n$innerSt');
      }

      state = state.copyWith(
        isOnline: false,
        serverError: e,
      );
      return;
    }

    // Step 4: listen for tracking failures.
    _subscribeToFailures(tracker);

    // Step 5: persist final state.
    await local.saveOnlineRequested(value: true);

    state = state.copyWith(isOnline: true);
  }

  // ---------------------------------------------------------------------------
  // Offline flow
  // ---------------------------------------------------------------------------

  // Full offline flow:
  // runtime -> tracking -> server -> local state
  Future<void> _goOffline() async {
    final setStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtime = ref.read(driverRuntimeControllerProvider);
    final local = ref.read(availabilityLocalDatasourceProvider);

    // Update UI first.
    state = state.copyWith(isOnline: false);

    // Stop runtime services.
    try {
      await runtime.stopOnlineRuntime();
    } on Exception catch (e, st) {
      debugPrint('stopOnlineRuntime failed: $e\n$st');
    }

    // Stop location tracking.
    await _stopTracking();

    // Mark driver offline on server.
    try {
      await setStatus(status: DriverStatus.offline);
    } on Exception catch (e, st) {
      debugPrint('setStatus OFFLINE failed: $e\n$st');
      state = state.copyWith(serverError: e);
    }

    // Persist final offline state.
    await local.saveOnlineRequested(value: false);
  }

  // ---------------------------------------------------------------------------
  // Failure subscriptions
  // ---------------------------------------------------------------------------

  // Start listening to tracking/runtime failures.
  void _subscribeToFailures(LocationTracker tracker) {
    if (_failuresSub != null) return;

    _failuresSub = tracker.failures.listen((reason) {
      if (!state.isOnline) return;
      _forceOffline(reason);
    });
  }

  // Force offline after a runtime failure.
  void _forceOffline(LocationFailureReason reason) {
    if (_autoStopping) return;
    _autoStopping = true;

    final runtime = ref.read(driverRuntimeControllerProvider);
    final local = ref.read(availabilityLocalDatasourceProvider);

    // Update UI immediately.
    state = state.copyWith(
      isOnline: false,
      errorReason: reason,
    );

    unawaited(
      Future.wait([
        _stopTracking(),
        runtime.stopOnlineRuntime(),
        local.saveOnlineRequested(value: false),
      ]).whenComplete(() async {
        try {
          await ref.read(setDriverStatusUseCaseProvider)(
            status: DriverStatus.offline,
          );
        } on Exception catch (e, st) {
          debugPrint('setStatus OFFLINE (force) failed: $e\n$st');
          state = state.copyWith(serverError: e);
        } finally {
          _autoStopping = false;
        }
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Tracking cleanup
  // ---------------------------------------------------------------------------

  // Stop active tracking resources.
  Future<void> _stopTracking() async {
    await _failuresSub?.cancel();
    _failuresSub = null;

    final stopTracking = ref.read(stopLocationTrackingUseCaseProvider);

    try {
      await stopTracking();
    } on Exception catch (e, st) {
      debugPrint('stopUseCase failed: $e\n$st');
    }
  }

  // ---------------------------------------------------------------------------
  // State helpers
  // ---------------------------------------------------------------------------

  void _setBusy(bool value) {
    state = state.copyWith(isBusy: value);
  }

  void _clearLocationError() {
    state = state.copyWith(errorReason: null);
  }

  void _clearServerError() {
    state = state.copyWith(serverError: null);
  }
}

final class AvailabilityState {
  const AvailabilityState({
    required this.isBusy,
    required this.isOnline,
    this.errorReason,
    this.serverError,
  });

  final bool isOnline;
  final bool isBusy;

  /// Location-related error for UI actions.
  final LocationFailureReason? errorReason;

  /// Server/API error while updating availability.
  final Object? serverError;

  static const Object _unset = Object();

  AvailabilityState copyWith({
    bool? isOnline,
    bool? isBusy,
    Object? errorReason = _unset,
    Object? serverError = _unset,
  }) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      errorReason: identical(errorReason, _unset)
          ? this.errorReason
          : errorReason as LocationFailureReason?,
      serverError: identical(serverError, _unset)
          ? this.serverError
          : serverError,
    );
  }
}
