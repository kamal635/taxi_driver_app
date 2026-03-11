import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
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
  bool _autoStopping = false;

  @override
  AvailabilityState build() {
    ref.onDispose(() {
      unawaited(_failuresSub?.cancel());
      _failuresSub = null;
    });

    return AvailabilityState(isOnline: false, isBusy: false);
  }

  // -----------------------------
  // Public API
  // -----------------------------

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

  void clearError() => _clearLocationError();
  void clearServerError() => _clearServerError();

  // -----------------------------
  // Online / Offline flows
  // -----------------------------

  Future<void> _goOnline() async {
    final startUseCase = ref.read(startLocationTrackingUseCaseProvider);
    final tracker = ref.read(locationTrackerProvider);
    final setStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtime = ref.read(driverRuntimeControllerProvider);

    // 1) Ensure GPS + permission are ready, then start tracking.
    final ready = await startUseCase();

    if (!ready.isSuccess) {
      state = state.copyWith(
        isOnline: false,
        errorReason: ready.reason ?? LocationFailureReason.unableToDetermine,
      );
      return;
    }

    // 2) Tell server: ONLINE.
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

    // 3) Start runtime services (socket for now).
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

    // 4) Listen to runtime location failures.
    _subscribeToFailures(tracker);

    // 5) Mark online.
    state = state.copyWith(isOnline: true);
  }

  Future<void> _goOffline() async {
    final setStatus = ref.read(setDriverStatusUseCaseProvider);
    final runtime = ref.read(driverRuntimeControllerProvider);

    // Update UI immediately.
    state = state.copyWith(isOnline: false);

    // Stop runtime first.
    try {
      await runtime.stopOnlineRuntime();
    } on Exception catch (e, st) {
      debugPrint('stopOnlineRuntime failed: $e\n$st');
    }

    // Stop tracking.
    await _stopTracking();

    // Tell server: OFFLINE.
    try {
      await setStatus(status: DriverStatus.offline);
    } on Exception catch (e, st) {
      debugPrint('setStatus OFFLINE failed: $e\n$st');
      state = state.copyWith(serverError: e);
    }
  }

  // -----------------------------
  // Failure handling
  // -----------------------------

  void _subscribeToFailures(LocationTracker tracker) {
    if (_failuresSub != null) return;

    _failuresSub = tracker.failures.listen((reason) {
      if (!state.isOnline) return;
      _forceOffline(reason);
    });
  }

  void _forceOffline(LocationFailureReason reason) {
    if (_autoStopping) return;
    _autoStopping = true;

    final runtime = ref.read(driverRuntimeControllerProvider);

    state = state.copyWith(
      isOnline: false,
      errorReason: reason,
    );

    unawaited(
      Future.wait([
        _stopTracking(),
        runtime.stopOnlineRuntime(),
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

  Future<void> _stopTracking() async {
    await _failuresSub?.cancel();
    _failuresSub = null;

    final stopUseCase = ref.read(stopLocationTrackingUseCaseProvider);

    try {
      await stopUseCase();
    } on Exception catch (e, st) {
      debugPrint('stopUseCase failed: $e\n$st');
    }
  }

  // -----------------------------
  // Small helpers
  // -----------------------------

  void _setBusy(bool v) => state = state.copyWith(isBusy: v);

  void _clearLocationError() => state = state.copyWith(errorReason: null);

  void _clearServerError() => state = state.copyWith(serverError: null);
}

final class AvailabilityState {
  AvailabilityState({
    required this.isBusy,
    required this.isOnline,
    this.errorReason,
    this.serverError,
  });

  final bool isOnline;
  final bool isBusy;

  /// Location-specific error (for Settings actions).
  final LocationFailureReason? errorReason;

  /// Server/API error (e.g. failed to set ONLINE/OFFLINE).
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
