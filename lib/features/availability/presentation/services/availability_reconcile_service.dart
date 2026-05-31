import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_runtime_cleanup_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Result of reconciling persisted online intent with native runtime state.
final class AvailabilityReconcileResult {
  const AvailabilityReconcileResult._({
    required this.isOnline,
    this.tracker,
  });

  factory AvailabilityReconcileResult.online({
    required LocationTracker tracker,
  }) {
    return AvailabilityReconcileResult._(
      isOnline: true,
      tracker: tracker,
    );
  }

  factory AvailabilityReconcileResult.offline() {
    return const AvailabilityReconcileResult._(isOnline: false);
  }

  final bool isOnline;
  final LocationTracker? tracker;
}

/// Restores local availability state after app launch or resume.
final class AvailabilityReconcileService {
  AvailabilityReconcileService(this._ref)
    : _cleanup = AvailabilityRuntimeCleanupService(_ref);

  final Ref _ref;
  final AvailabilityRuntimeCleanupService _cleanup;

  Future<AvailabilityReconcileResult> reconcile() async {
    final localDataSource = _ref.read(availabilityLocalDataSourceProvider);
    final serviceBridge = _ref.read(driverBackgroundServiceBridgeProvider);
    final locationTracker = _ref.read(locationTrackerProvider);

    final onlineRequested = await localDataSource.getOnlineRequested();
    final isServiceRunning = await serviceBridge.isServiceRunning();

    if (!onlineRequested) {
      return AvailabilityReconcileResult.offline();
    }

    if (!isServiceRunning) {
      await _cleanup.stopTrackingSafely();
      await _cleanup.stopOnlineRuntimeSafely(context: 'during reconcile');
      await _cleanup.saveOnlineIntent(value: false);

      return AvailabilityReconcileResult.offline();
    }

    await locationTracker.start();

    return AvailabilityReconcileResult.online(tracker: locationTracker);
  }
}
