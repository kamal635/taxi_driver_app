import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_providers.dart';

/// Coordinates services that must run while the driver is online.
class DriverRuntimeController {
  DriverRuntimeController(this._ref);

  final Ref _ref;

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
      throw StateError(
        'Auth session is not ready for background driver mode.',
      );
    }

    final permissionGranted = await bridge.ensureNotificationPermission();

    if (!permissionGranted) {
      throw StateError(
        'Notification permission is required to start background driver mode.',
      );
    }

    await bridge.startService(
      token: token,
      driverId: driverId,
    );

    final isRunning = await _waitForServiceRunning(bridge);

    if (!isRunning) {
      throw StateError('Background service did not start successfully.');
    }
  }

  /// Stops the complete runtime required for online mode.
  Future<void> stopOnlineRuntime() async {
    await _ref.read(driverBackgroundServiceBridgeProvider).stopService();
  }

  Future<bool> _waitForServiceRunning(
    DriverBackgroundServiceBridge bridge,
  ) async {
    const maxAttempts = 20;
    const delay = Duration(milliseconds: 150);

    for (var i = 0; i < maxAttempts; i++) {
      final isRunning = await bridge.isServiceRunning();

      if (isRunning) {
        return true;
      }

      await Future<void>.delayed(delay);
    }

    return false;
  }
}
