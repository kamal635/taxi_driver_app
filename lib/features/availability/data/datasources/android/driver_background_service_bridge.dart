import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the native Android background service bridge.
final driverBackgroundServiceBridgeProvider =
    Provider<DriverBackgroundServiceBridge>((ref) {
      final bridge = DriverBackgroundServiceBridge();

      ref.onDispose(bridge.dispose);

      return bridge;
    });

// Represents an event coming from the native background service.
final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

class DriverBackgroundServiceBridge {
  DriverBackgroundServiceBridge() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  // ---------------------------------------------------------------------------
  // Channel
  // ---------------------------------------------------------------------------

  static const MethodChannel _channel = MethodChannel(
    'driver_background_service',
  );

  final StreamController<DriverBackgroundServiceEvent> _eventsController =
      StreamController<DriverBackgroundServiceEvent>.broadcast();

  // Public stream of native service events.
  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _eventsController.stream;

  // ---------------------------------------------------------------------------
  // Native callbacks
  // ---------------------------------------------------------------------------

  // Handle incoming calls from native Android code.
  Future<void> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'serviceStopped':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        final reason = args['reason']?.toString() ?? 'unknown';

        _eventsController.add(
          DriverBackgroundServiceEvent(reason: reason),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  // Request notification permission when needed.
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

  // ---------------------------------------------------------------------------
  // Service control
  // ---------------------------------------------------------------------------

  // Start the native foreground service with runtime data.
  Future<void> startService({
    required String token,
    required String driverId,
  }) async {
    await _channel.invokeMethod(
      'startService',
      {
        'token': token,
        'driverId': driverId,
      },
    );
  }

  // Stop the native foreground service.
  Future<void> stopService() async {
    await _channel.invokeMethod('stopService');
  }

  // Check whether the native service is currently running.
  Future<bool> isServiceRunning() async {
    final result = await _channel.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  // Release native callbacks and close the event stream.
  void dispose() {
    _channel.setMethodCallHandler(null);
    unawaited(_eventsController.close());
  }
}
