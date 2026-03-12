import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

// Provides the runtime coordinator for driver online mode.
final driverRuntimeControllerProvider = Provider<DriverRuntimeController>(
  DriverRuntimeController.new,
);

class DriverRuntimeController {
  DriverRuntimeController(this.ref);

  final Ref ref;

  // Start the full online runtime.
  // Current flow:
  // 1) Request notification permission
  // 2) Start Android foreground service
  // 3) Verify that the service is running
  // 4) Start socket offer listening
  Future<void> startOnlineRuntime() async {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    // Notification permission is required on Android 13+.
    final permissionGranted = await bridge.ensureNotificationPermission();

    if (!permissionGranted) {
      throw StateError(
        'Notification permission is required to start background driver mode.',
      );
    }

    // Start the native Android foreground service.
    await bridge.startService();

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

  // Stop the full online runtime.
  // Current flow:
  // 1) Stop socket offer listening
  // 2) Stop Android foreground service
  Future<void> stopOnlineRuntime() async {
    // Stop socket-based runtime first.
    await ref.read(newOfferControllerProvider.notifier).stop();

    // Stop the native Android foreground service.
    await ref.read(driverBackgroundServiceBridgeProvider).stopService();
  }
}
