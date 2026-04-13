import 'dart:async' show StreamController, unawaited;
import 'dart:io';

import 'package:flutter/services.dart';

final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

final class DriverBackgroundOfferEvent {
  const DriverBackgroundOfferEvent({
    required this.payloadJson,
  });

  final String payloadJson;
}

final class DriverOfferNotificationOpenEvent {
  const DriverOfferNotificationOpenEvent({
    required this.offerId,
    required this.payloadJson,
  });

  final String? offerId;
  final String? payloadJson;
}

final class DriverForceLogoutEvent {
  const DriverForceLogoutEvent({
    required this.reason,
    required this.payloadJson,
  });

  final String reason;
  final String? payloadJson;
}

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

  final StreamController<DriverForceLogoutEvent> _forceLogoutController =
      StreamController<DriverForceLogoutEvent>.broadcast();

  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _serviceEventsController.stream;

  Stream<DriverBackgroundOfferEvent> get offerEvents =>
      _offerEventsController.stream;

  Stream<DriverOfferNotificationOpenEvent> get offerNotificationOpens =>
      _offerNotificationOpenController.stream;

  Stream<DriverForceLogoutEvent> get forceLogoutEvents =>
      _forceLogoutController.stream;

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

      case 'forceLogout':
        final args = Map<Object?, Object?>.from(
          call.arguments as Map? ?? const {},
        );

        _forceLogoutController.add(
          DriverForceLogoutEvent(
            reason: args['reason']?.toString() ?? 'force_logout',
            payloadJson: args['payloadJson']?.toString(),
          ),
        );
        return;

      default:
        return;
    }
  }

  Future<bool> ensureNotificationPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'ensureNotificationPermission',
    );
    return result ?? false;
  }

  Future<bool> areNotificationsEnabled() async {
    final result = await _channel.invokeMethod<bool>('areNotificationsEnabled');
    return result ?? false;
  }

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

  Future<void> stopOfferAlert({
    bool cancelNotification = true,
  }) async {
    await _channel.invokeMethod(
      'stopOfferAlert',
      {
        'cancelNotification': cancelNotification,
      },
    );
  }

  Future<DriverOfferNotificationOpenEvent?>
  consumePendingOfferNotificationOpen() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>?>(
      'consumePendingOfferNotificationOpen',
    );

    if (result == null) return null;

    return DriverOfferNotificationOpenEvent(
      offerId: result['offerId']?.toString(),
      payloadJson: result['payloadJson']?.toString(),
    );
  }

  Future<DriverForceLogoutEvent?> consumePendingForceLogout() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>?>(
      'consumePendingForceLogout',
    );

    if (result == null) return null;

    return DriverForceLogoutEvent(
      reason: result['reason']?.toString() ?? 'force_logout',
      payloadJson: result['payloadJson']?.toString(),
    );
  }

  Future<bool> isServiceRunning() async {
    final result = await _channel.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }

  Future<void> emitTestOffer() async {
    await _channel.invokeMethod('emitTestOffer');
  }

  Future<bool> ensureLocationSettings() async {
    if (!Platform.isAndroid) return true;

    final result = await _channel.invokeMethod<bool>('ensureLocationSettings');
    return result ?? false;
  }

  void dispose() {
    _channel.setMethodCallHandler(null);

    unawaited(_serviceEventsController.close());
    unawaited(_offerEventsController.close());
    unawaited(_offerNotificationOpenController.close());
    unawaited(_forceLogoutController.close());
  }
}
