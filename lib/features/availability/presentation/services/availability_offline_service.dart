import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_runtime_cleanup_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Coordinates repeated local/backend cleanup steps when availability stops.
final class AvailabilityOfflineService {
  AvailabilityOfflineService(this._ref)
    : _cleanup = AvailabilityRuntimeCleanupService(_ref);

  final Ref _ref;
  final AvailabilityRuntimeCleanupService _cleanup;

  Future<Object?> goManualOffline({
    required Future<void> Function() stopTracking,
  }) async {
    await _cleanup.stopOnlineRuntimeSafely(context: 'manual offline');
    await stopTracking();

    final error = await _setBackendOffline(logLabel: 'OFFLINE');
    await _cleanup.saveOnlineIntent(value: false);

    return error;
  }

  Future<Object?> forceOfflineBecauseOfLocationFailure({
    required Future<void> Function() stopTracking,
  }) async {
    await stopTracking();
    await _cleanup.stopOnlineRuntimeSafely(context: 'location failure');
    await _cleanup.saveOnlineIntent(value: false);

    return _setBackendOffline(logLabel: 'OFFLINE (force)');
  }

  Future<void> stopLocalRuntimeOnly({
    required String context,
    required Future<void> Function() stopTracking,
  }) async {
    await _cleanup.stopOnlineRuntimeSafely(context: context);
    await stopTracking();
    await _cleanup.saveOnlineIntent(value: false);
  }

  Future<Object?> _setBackendOffline({required String logLabel}) async {
    try {
      await _ref.read(setDriverStatusUseCaseProvider)(
        status: DriverStatus.offline,
      );
      return null;
    } on Exception catch (error, stackTrace) {
      debugPrint('setStatus $logLabel failed: $error\n$stackTrace');
      return error;
    }
  }
}
