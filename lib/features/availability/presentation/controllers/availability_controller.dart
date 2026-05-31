import 'dart:async' show StreamSubscription, unawaited;

import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/domain/failures/availability_runtime_failure.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_offline_service.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_online_start_service.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_reconcile_service.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_runtime_cleanup_service.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/state/availability_state.dart';
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

  AvailabilityRuntimeCleanupService get _cleanup =>
      AvailabilityRuntimeCleanupService(ref);

  AvailabilityOfflineService get _offlineService => AvailabilityOfflineService(
    ref,
  );

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

    await _offlineService.stopLocalRuntimeOnly(
      context: 'after accept',
      stopTracking: _stopTracking,
    );
  }

  /// Reconciles availability after app launch or resume.
  Future<void> reconcileAvailabilityOnAppStartOrResume() async {
    if (_isReconciling) return;
    _isReconciling = true;

    try {
      final result = await AvailabilityReconcileService(ref).reconcile();

      if (!result.isOnline) {
        _markLocallyOffline();
        return;
      }

      final tracker = result.tracker;
      if (tracker != null) {
        _subscribeToLocationFailures(tracker);
      }

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

    await _offlineService.stopLocalRuntimeOnly(
      context: 'force local cleanup',
      stopTracking: _stopTracking,
    );
  }

  void clearLocationError() => _clearLocationError();

  void clearServerError() => _clearServerError();

  Future<void> _goOnline() async {
    final result = await AvailabilityOnlineStartService(ref).start();

    if (!result.isOnline) {
      state = state.copyWith(
        isOnline: false,
        locationError: result.locationError,
        serverError: result.serverError,
      );
      return;
    }

    final tracker = result.tracker;
    if (tracker != null) {
      _subscribeToLocationFailures(tracker);
    }

    state = state.copyWith(
      isOnline: true,
      locationError: null,
      serverError: null,
    );
  }

  Future<void> _goOffline() async {
    _markLocallyOffline();

    final error = await _offlineService.goManualOffline(
      stopTracking: _stopTracking,
    );

    if (error != null) {
      state = state.copyWith(serverError: error);
    }
  }

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
      await _offlineService.stopLocalRuntimeOnly(
        context: 'unexpected native stop',
        stopTracking: _stopTracking,
      );
    } finally {
      _isAutoStopping = false;
    }
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
      final error = await _offlineService.forceOfflineBecauseOfLocationFailure(
        stopTracking: _stopTracking,
      );

      if (error != null) {
        state = state.copyWith(serverError: error);
      }
    } finally {
      _isAutoStopping = false;
    }
  }

  Future<void> _stopTracking() async {
    await _locationFailuresSubscription?.cancel();
    _locationFailuresSubscription = null;

    await _cleanup.stopTrackingSafely();
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
