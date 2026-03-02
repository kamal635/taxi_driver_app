import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_tracking_providers.dart';

final availabilityProvider =
    NotifierProvider<AvailabilityController, AvailabilityState>(
      AvailabilityController.new,
    );

class AvailabilityController extends Notifier<AvailabilityState> {
  // Subscription to runtime tracking failures (emitted by LocationTracker).
  StreamSubscription<LocationFailureReason>? _failuresSub;

  // Prevent re-entrancy when forcing offline due to failures.
  bool _autoStopping = false;

  @override
  AvailabilityState build() {
    // Cleanup: cancel the failures subscription when this notifier is disposed.
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
    // Guard: prevent double taps / concurrent calls.
    if (state.isBusy) return;

    _setBusy(true);
    _clearError();

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

  void clearError() => _clearError();

  // -----------------------------
  // Online / Offline flows
  // -----------------------------

  Future<void> _goOnline() async {
    final startUseCase = ref.read(startLocationTrackingUseCaseProvider);
    final tracker = ref.read(locationTrackerProvider);

    // 1) Ensure GPS + permission are ready, then start tracking.
    final ready = await startUseCase();

    // If not ready, keep offline and publish the reason for the UI (SnackBar).
    if (!ready.isSuccess) {
      state = state.copyWith(
        isOnline: false,
        errorReason: ready.reason ?? LocationFailureReason.unableToDetermine,
      );
      return;
    }

    // 2) Subscribe to runtime failures while online.
    _subscribeToFailures(tracker);

    // 3) Mark online.
    state = state.copyWith(isOnline: true);
  }

  Future<void> _goOffline() async {
    // Stop tracking + cancel failure subscription.
    await _stopTracking();

    // Mark offline.
    state = state.copyWith(isOnline: false);
  }

  // -----------------------------
  // Failure handling
  // -----------------------------

  void _subscribeToFailures(LocationTracker tracker) {
    // Ensure a single subscription.
    if (_failuresSub != null) return;

    _failuresSub = tracker.failures.listen((reason) {
      // If already offline, ignore.
      if (!state.isOnline) return;

      // Policy (minimal): any failure forces offline immediately.
      _forceOffline(reason);
    });
  }

  void _forceOffline(LocationFailureReason reason) {
    // Prevent re-entrancy if multiple failure events arrive quickly.
    if (_autoStopping) return;
    _autoStopping = true;

    // Update state immediately so the UI reflects the offline status.
    state = state.copyWith(isOnline: false, errorReason: reason);

    // Stop tracking in the background (best-effort).
    unawaited(
      _stopTracking().whenComplete(() {
        _autoStopping = false;
      }),
    );
  }

  Future<void> _stopTracking() async {
    // Cancel subscription first to avoid handling events during stop().
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

  void _clearError() => state = state.copyWith(errorReason: null);
}

final class AvailabilityState {
  AvailabilityState({
    required this.isBusy,
    required this.isOnline,
    this.errorReason,
  });

  final bool isOnline;
  final bool isBusy;

  /// Reason-based error (best for localization in UI).
  final LocationFailureReason? errorReason;

  static const Object _unset = Object();

  AvailabilityState copyWith({
    bool? isOnline,
    bool? isBusy,
    Object? errorReason = _unset,
  }) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      errorReason: identical(errorReason, _unset)
          ? this.errorReason
          : errorReason as LocationFailureReason?,
    );
  }
}
