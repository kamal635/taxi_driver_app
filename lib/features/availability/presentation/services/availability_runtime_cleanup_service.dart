import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralizes best-effort cleanup actions used by availability flows.
final class AvailabilityRuntimeCleanupService {
  const AvailabilityRuntimeCleanupService(this._ref);

  final Ref _ref;

  Future<void> stopTrackingSafely() async {
    final stopTracking = _ref.read(stopLocationTrackingUseCaseProvider);

    try {
      await stopTracking();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopTracking failed: $error\n$stackTrace');
    }
  }

  Future<void> stopOnlineRuntimeSafely({required String context}) async {
    final runtimeController = _ref.read(driverRuntimeControllerProvider);

    try {
      await runtimeController.stopOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint('stopOnlineRuntime $context failed: $error\n$stackTrace');
    }
  }

  Future<void> saveOnlineIntent({required bool value}) async {
    final localDataSource = _ref.read(availabilityLocalDataSourceProvider);

    try {
      await localDataSource.saveOnlineRequested(value: value);
    } on Exception catch (error, stackTrace) {
      debugPrint('saveOnlineRequested($value) failed: $error\n$stackTrace');
    }
  }
}
