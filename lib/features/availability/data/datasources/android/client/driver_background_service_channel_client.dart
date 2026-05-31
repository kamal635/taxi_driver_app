import 'dart:io' show Platform;

import 'package:bawabat_al_saeq/features/availability/data/datasources/android/events/driver_background_service_events.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/utils/driver_background_service_arguments_reader.dart';
import 'package:flutter/services.dart';

/// Low-level wrapper around the Android driver background service channel.
final class DriverBackgroundServiceChannelClient {
  const DriverBackgroundServiceChannelClient();

  static const MethodChannel _channel = MethodChannel(
    'driver_background_service',
  );

  bool get _isAndroid => Platform.isAndroid;

  void setMethodCallHandler(
    Future<dynamic> Function(MethodCall call)? handler,
  ) {
    _channel.setMethodCallHandler(handler);
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
      offerId: DriverBackgroundServiceArgumentsReader.nullableString(
        result,
        'offerId',
      ),
      payloadJson: DriverBackgroundServiceArgumentsReader.nullableString(
        result,
        'payloadJson',
      ),
    );
  }

  Future<DriverForceLogoutEvent?> consumePendingForceLogout() async {
    if (!_isAndroid) return null;

    final result = await _channel.invokeMethod<Map<Object?, Object?>?>(
      'consumePendingForceLogout',
    );

    if (result == null) return null;

    return DriverForceLogoutEvent(
      reason: DriverBackgroundServiceArgumentsReader.string(
        result,
        'reason',
        fallback: 'force_logout',
      ),
      payloadJson: DriverBackgroundServiceArgumentsReader.nullableString(
        result,
        'payloadJson',
      ),
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
}
