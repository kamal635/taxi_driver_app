import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/services/availability_runtime_cleanup_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Result produced when trying to move the driver into online runtime.
final class AvailabilityOnlineStartResult {
  const AvailabilityOnlineStartResult._({
    required this.isOnline,
    this.locationError,
    this.serverError,
    this.tracker,
  });

  factory AvailabilityOnlineStartResult.online({
    required LocationTracker tracker,
  }) {
    return AvailabilityOnlineStartResult._(
      isOnline: true,
      tracker: tracker,
    );
  }

  factory AvailabilityOnlineStartResult.locationFailure(
    LocationFailureReason reason,
  ) {
    return AvailabilityOnlineStartResult._(
      isOnline: false,
      locationError: reason,
    );
  }

  factory AvailabilityOnlineStartResult.serverFailure(Object error) {
    return AvailabilityOnlineStartResult._(
      isOnline: false,
      serverError: error,
    );
  }

  final bool isOnline;
  final LocationFailureReason? locationError;
  final Object? serverError;
  final LocationTracker? tracker;
}

/// Coordinates the ordered startup steps needed before marking a driver online.
final class AvailabilityOnlineStartService {
  AvailabilityOnlineStartService(this._ref)
    : _cleanup = AvailabilityRuntimeCleanupService(_ref);

  final Ref _ref;
  final AvailabilityRuntimeCleanupService _cleanup;

  Future<AvailabilityOnlineStartResult> start() async {
    final serviceBridge = _ref.read(driverBackgroundServiceBridgeProvider);
    final startTracking = _ref.read(startLocationTrackingUseCaseProvider);
    final locationTracker = _ref.read(locationTrackerProvider);
    final setDriverStatus = _ref.read(setDriverStatusUseCaseProvider);
    final runtimeController = _ref.read(driverRuntimeControllerProvider);

    final locationSettingsReady = await serviceBridge.ensureLocationSettings();

    if (!locationSettingsReady) {
      return AvailabilityOnlineStartResult.locationFailure(
        LocationFailureReason.serviceDisabled,
      );
    }

    final locationReadyResult = await startTracking();

    if (!locationReadyResult.isSuccess) {
      return AvailabilityOnlineStartResult.locationFailure(
        locationReadyResult.reason ?? LocationFailureReason.unableToDetermine,
      );
    }

    try {
      await setDriverStatus(status: DriverStatus.online);
    } on Exception catch (error, stackTrace) {
      debugPrint('setStatus ONLINE failed: $error\n$stackTrace');

      await _cleanup.stopTrackingSafely();
      return AvailabilityOnlineStartResult.serverFailure(error);
    }

    try {
      await runtimeController.startOnlineRuntime();
    } on Exception catch (error, stackTrace) {
      debugPrint('startOnlineRuntime failed: $error\n$stackTrace');

      await _cleanup.stopTrackingSafely();
      await _rollbackBackendOfflineAfterFailedOnlineStart();

      return AvailabilityOnlineStartResult.serverFailure(error);
    }

    await _cleanup.saveOnlineIntent(value: true);

    return AvailabilityOnlineStartResult.online(tracker: locationTracker);
  }

  Future<void> _rollbackBackendOfflineAfterFailedOnlineStart() async {
    try {
      await _ref.read(setDriverStatusUseCaseProvider)(
        status: DriverStatus.offline,
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('rollback OFFLINE failed: $error\n$stackTrace');
    }
  }
}
