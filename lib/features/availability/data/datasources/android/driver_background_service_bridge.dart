import 'dart:async' show StreamController, unawaited;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides access to the native Android background service bridge.
final driverBackgroundServiceBridgeProvider =
    Provider<DriverBackgroundServiceBridge>((ref) {
      final bridge = DriverBackgroundServiceBridge();

      ref.onDispose(bridge.dispose);

      return bridge;
    });

// Represents a stop event coming from the native background service.
final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

// Represents an incoming offer payload from the native background service.
final class DriverBackgroundOfferEvent {
  const DriverBackgroundOfferEvent({
    required this.payloadJson,
  });

  final String payloadJson;
}

// Represents opening the app from an offer notification.
final class DriverOfferNotificationOpenEvent {
  const DriverOfferNotificationOpenEvent({
    required this.offerId,
  });

  final String? offerId;
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

  final StreamController<DriverBackgroundServiceEvent>
  _serviceEventsController =
      StreamController<DriverBackgroundServiceEvent>.broadcast();

  final StreamController<DriverBackgroundOfferEvent> _offerEventsController =
      StreamController<DriverBackgroundOfferEvent>.broadcast();

  final StreamController<DriverOfferNotificationOpenEvent>
  _offerNotificationOpenController =
      StreamController<DriverOfferNotificationOpenEvent>.broadcast();

  // Public stream of native service stop events.
  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _serviceEventsController.stream;

  // Public stream of incoming native offer payloads.
  Stream<DriverBackgroundOfferEvent> get offerEvents =>
      _offerEventsController.stream;

  // Public stream of app opens triggered by offer notifications.
  Stream<DriverOfferNotificationOpenEvent> get offerNotificationOpens =>
      _offerNotificationOpenController.stream;

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

        _serviceEventsController.add(
          DriverBackgroundServiceEvent(reason: reason),
        );

      case 'offerReceived':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        final payloadJson = args['payloadJson']?.toString() ?? '{}';

        _offerEventsController.add(
          DriverBackgroundOfferEvent(
            payloadJson: payloadJson,
          ),
        );

      case 'offerNotificationOpened':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        final offerId = args['offerId']?.toString();

        _offerNotificationOpenController.add(
          DriverOfferNotificationOpenEvent(offerId: offerId),
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

  // Temporary test hook for native-to-Flutter offer pipeline.
  Future<void> emitTestOffer() async {
    await _channel.invokeMethod('emitTestOffer');
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  // Release native callbacks and close all event streams.
  void dispose() {
    _channel.setMethodCallHandler(null);

    unawaited(_serviceEventsController.close());
    unawaited(_offerEventsController.close());
    unawaited(_offerNotificationOpenController.close());
  }
}
