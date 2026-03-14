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

// Represents a stop event coming from the native background service.
final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

// Represents an offer event coming from the native background service.
final class DriverBackgroundOfferEvent {
  const DriverBackgroundOfferEvent({
    required this.payloadJson,
  });

  final String payloadJson;
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

  final StreamController<DriverBackgroundOfferEvent> _offerEventsController =
      StreamController<DriverBackgroundOfferEvent>.broadcast();

  // Public stream of native service events.
  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _eventsController.stream;

  // Public stream of native offer events.
  Stream<DriverBackgroundOfferEvent> get offerEvents =>
      _offerEventsController.stream;

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
    }
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  Future<bool> ensureNotificationPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'ensureNotificationPermission',
    );
    return result ?? false;
  }

  Future<bool> areNotificationsEnabled() async {
    final result = await _channel.invokeMethod<bool>(
      'areNotificationsEnabled',
    );
    return result ?? false;
  }

  // ---------------------------------------------------------------------------
  // Service control
  // ---------------------------------------------------------------------------

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

  Future<void> stopService() async {
    await _channel.invokeMethod('stopService');
  }

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

  void dispose() {
    _channel.setMethodCallHandler(null);
    unawaited(_eventsController.close());
    unawaited(_offerEventsController.close());
  }
}
