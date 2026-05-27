import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/domain/failures/availability_runtime_failure.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Coordinates local runtime services that must run while the driver is online.
final class DriverRuntimeController {
  DriverRuntimeController(this._ref);

  final Ref _ref;

  static const int _maxServiceStartChecks = 20;
  static const Duration _serviceStartCheckDelay = Duration(milliseconds: 150);

  /// Starts the complete runtime required for online mode.
  Future<void> startOnlineRuntime() async {
    final bridge = _ref.read(driverBackgroundServiceBridgeProvider);
    final session = _ref.read(authSessionProvider);

    final token = session.token;
    final driverId = session.driverId;

    if (token == null ||
        token.isEmpty ||
        driverId == null ||
        driverId.isEmpty) {
      throw const AvailabilityRuntimeFailure(
        reason: AvailabilityRuntimeFailureReason.missingAuthSession,
      );
    }

    final permissionGranted = await bridge.ensureNotificationPermission();

    if (!permissionGranted) {
      throw const AvailabilityRuntimeFailure(
        reason: AvailabilityRuntimeFailureReason.notificationPermissionDenied,
      );
    }

    await bridge.startService(
      token: token,
      driverId: driverId,
    );

    final isRunning = await _waitForServiceRunning(bridge);

    if (!isRunning) {
      throw const AvailabilityRuntimeFailure(
        reason: AvailabilityRuntimeFailureReason.backgroundServiceStartFailed,
      );
    }
  }

  /// Stops the complete runtime required for online mode.
  Future<void> stopOnlineRuntime() async {
    await _ref.read(driverBackgroundServiceBridgeProvider).stopService();
  }

  Future<bool> _waitForServiceRunning(
    DriverBackgroundServiceBridge bridge,
  ) async {
    for (var i = 0; i < _maxServiceStartChecks; i++) {
      final isRunning = await bridge.isServiceRunning();

      if (isRunning) {
        return true;
      }

      await Future<void>.delayed(_serviceStartCheckDelay);
    }

    return false;
  }
}
