import 'dart:async' show StreamController, unawaited;
import 'dart:io';

import 'package:flutter/services.dart';

/// Represents a stop event emitted by the native background service.
final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

/// Represents an incoming offer
/// payload emitted by the native background service.
final class DriverBackgroundOfferEvent {
  const DriverBackgroundOfferEvent({
    required this.payloadJson,
  });

  final String payloadJson;
}

/// Represents opening the app from an offer notification.
final class DriverOfferNotificationOpenEvent {
  const DriverOfferNotificationOpenEvent({
    required this.offerId,
    required this.payloadJson,
  });

  final String? offerId;
  final String? payloadJson;
}

/// Bridges Flutter code with the native Android driver background service.
class DriverBackgroundServiceBridge {
  DriverBackgroundServiceBridge() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

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

  /// Emits native service stop events.
  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _serviceEventsController.stream;

  /// Emits raw offer payloads coming from the native side.
  Stream<DriverBackgroundOfferEvent> get offerEvents =>
      _offerEventsController.stream;

  /// Emits app-open events triggered by offer notifications.
  Stream<DriverOfferNotificationOpenEvent> get offerNotificationOpens =>
      _offerNotificationOpenController.stream;

  Future<void> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'serviceStopped':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        _serviceEventsController.add(
          DriverBackgroundServiceEvent(
            reason: args['reason']?.toString() ?? 'unknown',
          ),
        );
        return;

      case 'offerReceived':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        _offerEventsController.add(
          DriverBackgroundOfferEvent(
            payloadJson: args['payloadJson']?.toString() ?? '{}',
          ),
        );
        return;

      case 'offerNotificationOpened':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        _offerNotificationOpenController.add(
          DriverOfferNotificationOpenEvent(
            offerId: args['offerId']?.toString(),
            payloadJson: args['payloadJson']?.toString(),
          ),
        );
        return;

      default:
        return;
    }
  }

  /// Requests notification permission when needed.
  Future<bool> ensureNotificationPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'ensureNotificationPermission',
    );
    return result ?? false;
  }

  /// Returns whether notifications are currently enabled for the app.
  Future<bool> areNotificationsEnabled() async {
    final result = await _channel.invokeMethod<bool>('areNotificationsEnabled');
    return result ?? false;
  }

  /// Starts the native foreground service with the required runtime data.
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

  /// Stops the native foreground service.
  Future<void> stopService() async {
    await _channel.invokeMethod('stopService');
  }

  /// Returns whether the native service is running right now.
  Future<bool> isServiceRunning() async {
    final result = await _channel.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }

  /// Temporary test hook for validating the native-to-Flutter offer pipeline.
  Future<void> emitTestOffer() async {
    await _channel.invokeMethod('emitTestOffer');
  }

  /// Opens native location settings resolution on Android when needed.
  Future<bool> ensureLocationSettings() async {
    if (!Platform.isAndroid) return true;

    final result = await _channel.invokeMethod<bool>('ensureLocationSettings');
    return result ?? false;
  }

  /// Releases the native method handler and closes all event streams.
  void dispose() {
    _channel.setMethodCallHandler(null);

    unawaited(_serviceEventsController.close());
    unawaited(_offerEventsController.close());
    unawaited(_offerNotificationOpenController.close());
  }
}
