import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the native Android background service bridge.
final driverBackgroundServiceBridgeProvider =
    Provider<DriverBackgroundServiceBridge>(
      (ref) => const DriverBackgroundServiceBridge(),
    );

class DriverBackgroundServiceBridge {
  const DriverBackgroundServiceBridge();

  // Method channel used to communicate with native Android code.
  static const MethodChannel _channel = MethodChannel(
    'driver_background_service',
  );

  // Request notification permission.
  // Needed on Android 13+ before starting the foreground service.
  Future<bool> ensureNotificationPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'ensureNotificationPermission',
    );
    return result ?? false;
  }

  // Check whether notifications are enabled for the app.
  Future<bool> areNotificationsEnabled() async {
    final result = await _channel.invokeMethod<bool>(
      'areNotificationsEnabled',
    );
    return result ?? false;
  }

  // Ask Android to start the foreground service.
  Future<void> startService() async {
    await _channel.invokeMethod('startService');
  }

  // Ask Android to stop the foreground service.
  Future<void> stopService() async {
    await _channel.invokeMethod('stopService');
  }

  // Check whether the native foreground service is currently running.
  Future<bool> isServiceRunning() async {
    final result = await _channel.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }
}
