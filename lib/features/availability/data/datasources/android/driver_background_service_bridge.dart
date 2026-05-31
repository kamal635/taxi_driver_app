import 'dart:async' show StreamController, unawaited;

import 'package:bawabat_al_saeq/features/availability/data/datasources/android/client/driver_background_service_channel_client.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/events/driver_background_service_events.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/utils/driver_background_service_arguments_reader.dart';
import 'package:flutter/services.dart';

export 'package:bawabat_al_saeq/features/availability/data/datasources/android/events/driver_background_service_events.dart';

/// Thin Dart bridge over the Android foreground driver service.
///
/// All Android-specific calls are centralized here so the rest of the app can
/// depend on typed methods and streams instead of raw [MethodChannel] calls.
final class DriverBackgroundServiceBridge {
  DriverBackgroundServiceBridge({
    DriverBackgroundServiceChannelClient channelClient =
        const DriverBackgroundServiceChannelClient(),
  }) : _channelClient = channelClient {
    _channelClient.setMethodCallHandler(_handleNativeCall);
  }

  final DriverBackgroundServiceChannelClient _channelClient;

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

  Future<bool> ensureNotificationPermission() {
    return _channelClient.ensureNotificationPermission();
  }

  Future<bool> areNotificationsEnabled() {
    return _channelClient.areNotificationsEnabled();
  }

  Future<void> startService({
    required String token,
    required String driverId,
  }) {
    return _channelClient.startService(token: token, driverId: driverId);
  }

  Future<void> stopService() {
    return _channelClient.stopService();
  }

  Future<void> stopOfferAlert({bool cancelNotification = true}) {
    return _channelClient.stopOfferAlert(
      cancelNotification: cancelNotification,
    );
  }

  Future<DriverOfferNotificationOpenEvent?>
  consumePendingOfferNotificationOpen() {
    return _channelClient.consumePendingOfferNotificationOpen();
  }

  Future<DriverForceLogoutEvent?> consumePendingForceLogout() {
    return _channelClient.consumePendingForceLogout();
  }

  Future<bool> isServiceRunning() {
    return _channelClient.isServiceRunning();
  }

  Future<void> emitTestOffer() {
    return _channelClient.emitTestOffer();
  }

  Future<bool> ensureLocationSettings() {
    return _channelClient.ensureLocationSettings();
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    final args = DriverBackgroundServiceArgumentsReader.asMap(call.arguments);

    switch (call.method) {
      case 'serviceStopped':
        _addIfOpen(
          _serviceEventsController,
          DriverBackgroundServiceEvent(
            reason: DriverBackgroundServiceArgumentsReader.string(
              args,
              'reason',
              fallback: 'unknown',
            ),
          ),
        );
        return;

      case 'offerReceived':
        _addIfOpen(
          _offerEventsController,
          DriverBackgroundOfferEvent(
            payloadJson: DriverBackgroundServiceArgumentsReader.string(
              args,
              'payloadJson',
              fallback: '{}',
            ),
          ),
        );
        return;

      case 'offerNotificationOpened':
        _addIfOpen(
          _offerNotificationOpenController,
          DriverOfferNotificationOpenEvent(
            offerId: DriverBackgroundServiceArgumentsReader.nullableString(
              args,
              'offerId',
            ),
            payloadJson: DriverBackgroundServiceArgumentsReader.nullableString(
              args,
              'payloadJson',
            ),
          ),
        );
        return;

      case 'forceLogout':
        _addIfOpen(
          _forceLogoutController,
          DriverForceLogoutEvent(
            reason: DriverBackgroundServiceArgumentsReader.string(
              args,
              'reason',
              fallback: 'force_logout',
            ),
            payloadJson: DriverBackgroundServiceArgumentsReader.nullableString(
              args,
              'payloadJson',
            ),
          ),
        );
        return;

      default:
        return;
    }
  }

  void dispose() {
    _channelClient.setMethodCallHandler(null);

    unawaited(_serviceEventsController.close());
    unawaited(_offerEventsController.close());
    unawaited(_offerNotificationOpenController.close());
    unawaited(_forceLogoutController.close());
  }

  void _addIfOpen<T>(StreamController<T> controller, T event) {
    if (controller.isClosed) return;
    controller.add(event);
  }
}
