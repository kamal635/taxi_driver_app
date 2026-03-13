import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

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
  // 5) Start offer socket runtime
  Future<void> startOnlineRuntime() async {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);
    final session = ref.read(authSessionProvider);

    final token = session.token;
    final driverId = session.driverId;

    // Runtime start requires valid auth data.
    if (token == null ||
        token.isEmpty ||
        driverId == null ||
        driverId.isEmpty) {
      throw StateError(
        'Auth session is not ready for background driver mode.',
      );
    }

    // Notification permission is required on Android 13+.
    final permissionGranted = await bridge.ensureNotificationPermission();

    if (!permissionGranted) {
      throw StateError(
        'Notification permission is required to start background driver mode.',
      );
    }

    // Start the native foreground service with runtime data.
    await bridge.startService(
      token: token,
      driverId: driverId,
    );

    // Verify that the service is actually running.
    final isRunning = await bridge.isServiceRunning();

    if (!isRunning) {
      throw StateError(
        'Background service did not start successfully.',
      );
    }

    // Start socket-based offer listening.
    await ref.read(newOfferControllerProvider.notifier).start();
  }

  // ---------------------------------------------------------------------------
  // Stop
  // ---------------------------------------------------------------------------

  // Stop the full online runtime.
  // Flow:
  // 1) Stop offer socket runtime
  // 2) Stop native foreground service
  Future<void> stopOnlineRuntime() async {
    // Stop socket-based runtime first.
    await ref.read(newOfferControllerProvider.notifier).stop();

    // Stop the native Android foreground service.
    await ref.read(driverBackgroundServiceBridgeProvider).stopService();
  }
}
