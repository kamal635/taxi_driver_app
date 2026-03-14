import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';

// Provides the runtime coordinator for driver online mode.
final driverRuntimeControllerProvider = Provider<DriverRuntimeController>(
  DriverRuntimeController.new,
);

class DriverRuntimeController {
  DriverRuntimeController(this.ref);

  final Ref ref;

  // ---------------------------------------------------------------------------
  // Start
  // ---------------------------------------------------------------------------

  // Start the full online runtime.
  // Flow:
  // 1) Read auth session
  // 2) Request notification permission
  // 3) Start native foreground service
  // 4) Verify service state
  Future<void> startOnlineRuntime() async {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);
    final session = ref.read(authSessionProvider);

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
      throw StateError(
        'Background service did not start successfully.',
      );
    }
  }

  Future<bool> _waitForServiceRunning(
    DriverBackgroundServiceBridge bridge,
  ) async {
    const maxAttempts = 20;
    const delay = Duration(milliseconds: 150);

    for (var i = 0; i < maxAttempts; i++) {
      final isRunning = await bridge.isServiceRunning();

      if (isRunning) return true;

      await Future<void>.delayed(delay);
    }

    return false;
  }
  // ---------------------------------------------------------------------------
  // Stop
  // ---------------------------------------------------------------------------

  // Stop the full online runtime.
  // Flow:
  // 1) Stop native foreground service
  Future<void> stopOnlineRuntime() async {
    // Stop the native Android foreground service.
    await ref.read(driverBackgroundServiceBridgeProvider).stopService();
  }
}
