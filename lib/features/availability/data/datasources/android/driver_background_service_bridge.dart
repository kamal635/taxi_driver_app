import 'dart:async' show StreamController, unawaited;
import 'dart:io' show Platform;

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

/// Thin Dart bridge over the Android foreground driver service.
///
/// All Android-specific calls are centralized here so the rest of the app can
/// depend on typed methods and streams instead of raw [MethodChannel] calls.
final class DriverBackgroundServiceBridge {
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

  bool get _isAndroid => Platform.isAndroid;

  Stream<DriverBackgroundServiceEvent> get serviceEvents =>
      _serviceEventsController.stream;

  Stream<DriverBackgroundOfferEvent> get offerEvents =>
      _offerEventsController.stream;

  Stream<DriverOfferNotificationOpenEvent> get offerNotificationOpens =>
      _offerNotificationOpenController.stream;

  Stream<DriverForceLogoutEvent> get forceLogoutEvents =>
      _forceLogoutController.stream;

  Future<void> _handleNativeCall(MethodCall call) async {
    final args = _argumentsAsMap(call.arguments);

    switch (call.method) {
      case 'serviceStopped':
        _addIfOpen(
          _serviceEventsController,
          DriverBackgroundServiceEvent(
            reason: _readString(args, 'reason', fallback: 'unknown'),
          ),
        );
        return;

      case 'offerReceived':
        _addIfOpen(
          _offerEventsController,
          DriverBackgroundOfferEvent(
            payloadJson: _readString(args, 'payloadJson', fallback: '{}'),
          ),
        );
        return;

      case 'offerNotificationOpened':
        _addIfOpen(
          _offerNotificationOpenController,
          DriverOfferNotificationOpenEvent(
            offerId: _readNullableString(args, 'offerId'),
            payloadJson: _readNullableString(args, 'payloadJson'),
          ),
        );
        return;

      case 'forceLogout':
        _addIfOpen(
          _forceLogoutController,
          DriverForceLogoutEvent(
            reason: _readString(args, 'reason', fallback: 'force_logout'),
            payloadJson: _readNullableString(args, 'payloadJson'),
          ),
        );
        return;

      default:
        return;
    }
  }

  Future<bool> ensureNotificationPermission() async {
    if (!_isAndroid) return true;

    final result = await _channel.invokeMethod<bool>(
      'ensureNotificationPermission',
    );
    return result ?? false;
  }

  Future<bool> areNotificationsEnabled() async {
    if (!_isAndroid) return true;

    final result = await _channel.invokeMethod<bool>('areNotificationsEnabled');
    return result ?? false;
  }

  Future<void> startService({
    required String token,
    required String driverId,
  }) async {
    if (!_isAndroid) return;

    await _channel.invokeMethod<void>(
      'startService',
      {
        'token': token,
        'driverId': driverId,
      },
    );
  }

  Future<void> stopService() async {
    if (!_isAndroid) return;

    await _channel.invokeMethod<void>('stopService');
  }

  Future<void> stopOfferAlert({
    bool cancelNotification = true,
  }) async {
    if (!_isAndroid) return;

    await _channel.invokeMethod<void>(
      'stopOfferAlert',
      {
        'cancelNotification': cancelNotification,
      },
    );
  }

  Future<DriverOfferNotificationOpenEvent?>
  consumePendingOfferNotificationOpen() async {
    if (!_isAndroid) return null;

    final result = await _channel.invokeMethod<Map<Object?, Object?>?>(
      'consumePendingOfferNotificationOpen',
    );

    if (result == null) return null;

    return DriverOfferNotificationOpenEvent(
      offerId: _readNullableString(result, 'offerId'),
      payloadJson: _readNullableString(result, 'payloadJson'),
    );
  }

  Future<DriverForceLogoutEvent?> consumePendingForceLogout() async {
    if (!_isAndroid) return null;

    final result = await _channel.invokeMethod<Map<Object?, Object?>?>(
      'consumePendingForceLogout',
    );

    if (result == null) return null;

    return DriverForceLogoutEvent(
      reason: _readString(result, 'reason', fallback: 'force_logout'),
      payloadJson: _readNullableString(result, 'payloadJson'),
    );
  }

  Future<bool> isServiceRunning() async {
    if (!_isAndroid) return false;

    final result = await _channel.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }

  Future<void> emitTestOffer() async {
    if (!_isAndroid) return;

    await _channel.invokeMethod<void>('emitTestOffer');
  }

  Future<bool> ensureLocationSettings() async {
    if (!_isAndroid) return true;

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

  Map<Object?, Object?> _argumentsAsMap(Object? arguments) {
    if (arguments is Map<Object?, Object?>) {
      return arguments;
    }

    if (arguments is Map) {
      return Map<Object?, Object?>.from(arguments);
    }

    return const <Object?, Object?>{};
  }

  String _readString(
    Map<Object?, Object?> map,
    String key, {
    required String fallback,
  }) {
    final value = _readNullableString(map, key);
    if (value == null || value.isEmpty) {
      return fallback;
    }

    return value;
  }

  String? _readNullableString(Map<Object?, Object?> map, String key) {
    final value = map[key];
    if (value == null) return null;

    final text = value.toString();
    if (text.isEmpty || text == 'null') return null;

    return text;
  }

  void _addIfOpen<T>(StreamController<T> controller, T event) {
    if (controller.isClosed) return;
    controller.add(event);
  }
}
