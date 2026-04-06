import 'dart:async' show FutureOr, StreamSubscription, Timer, unawaited;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_providers.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/state/new_offer_state.dart';

final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

/// Stores the currently active pending offer received from background events.
final class NewOfferController extends AsyncNotifier<NewOfferState> {
  StreamSubscription<DriverBackgroundOfferEvent>? _offerEventsSubscription;
  StreamSubscription<DriverOfferNotificationOpenEvent>?
  _offerNotificationOpenSubscription;

  Timer? _expiryTimer;

  @override
  FutureOr<NewOfferState> build() {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _offerEventsSubscription ??= bridge.offerEvents.listen(
      _handleNativeOfferEvent,
    );

    _offerNotificationOpenSubscription ??= bridge.offerNotificationOpens.listen(
      _handleOfferNotificationOpened,
    );

    ref.onDispose(() {
      unawaited(_offerEventsSubscription?.cancel());
      _offerEventsSubscription = null;

      unawaited(_offerNotificationOpenSubscription?.cancel());
      _offerNotificationOpenSubscription = null;

      _cancelExpiryTimer();
    });

    return const NewOfferState();
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  void clearCurrent() {
    _cancelExpiryTimer();
    _stopNativeOfferAlert();

    state = AsyncData(
      _currentState.copyWith(currentOffer: null),
    );
  }

  void clearError() {
    state = AsyncData(
      _currentState.copyWith(errorMessage: null),
    );
  }

  void _handleNativeOfferEvent(DriverBackgroundOfferEvent event) {
    try {
      final offer = _parseOfferFromPayload(event.payloadJson);
      _storeOfferIfActive(offer);
    } on Exception catch (error, stackTrace) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: error.toString()),
      );

      debugPrint(
        'Failed to parse native background offer: $error\n$stackTrace',
      );
    }
  }

  void _handleOfferNotificationOpened(
    DriverOfferNotificationOpenEvent event,
  ) {
    debugPrint('Offer notification opened -> offerId=${event.offerId}');

    _stopNativeOfferAlert();

    final payloadJson = event.payloadJson;
    if (payloadJson == null || payloadJson.isEmpty) {
      debugPrint('Offer notification open ignored: missing payloadJson');
      return;
    }

    try {
      final offer = _parseOfferFromPayload(payloadJson);
      _storeOfferIfActive(offer);
    } on Exception catch (error, stackTrace) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: error.toString()),
      );

      debugPrint(
        'Failed to restore offer from notification open: '
        '$error\n$stackTrace',
      );
    }
  }

  NewOfferEntity _parseOfferFromPayload(String payloadJson) {
    final decoded = jsonDecode(payloadJson);

    if (decoded is! Map) {
      throw const FormatException('Offer payload is not a JSON object.');
    }

    final json = Map<String, dynamic>.from(decoded);
    final model = NewOfferModel.fromJson(json);

    return model.toEntity();
  }

  void _storeOfferIfActive(NewOfferEntity offer) {
    _cancelExpiryTimer();

    if (_isExpired(offer)) {
      _stopNativeOfferAlert();

      state = AsyncData(
        _currentState.copyWith(
          currentOffer: null,
          errorMessage: null,
        ),
      );

      debugPrint(
        'Ignoring expired native background offer -> id=${offer.offerId}',
      );
      return;
    }

    _scheduleExpiryTimer(offer);

    state = AsyncData(
      _currentState.copyWith(
        currentOffer: offer,
        errorMessage: null,
      ),
    );

    debugPrint(
      'Native background offer stored successfully -> id=${offer.offerId}',
    );
  }

  void _scheduleExpiryTimer(NewOfferEntity offer) {
    final remaining = offer.expiresAt.difference(DateTime.now());

    if (remaining <= Duration.zero) {
      clearCurrent();
      return;
    }

    _expiryTimer = Timer(remaining, () {
      final currentOffer = state.asData?.value.currentOffer;
      if (currentOffer?.offerId != offer.offerId) return;

      _stopNativeOfferAlert();

      state = AsyncData(_currentState.copyWith(currentOffer: null));

      debugPrint('Pending offer expired locally -> id=${offer.offerId}');
    });
  }

  void _cancelExpiryTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  void _stopNativeOfferAlert() {
    unawaited(
      ref.read(driverBackgroundServiceBridgeProvider).stopOfferAlert(),
    );
  }

  bool _isExpired(NewOfferEntity offer) {
    return !offer.expiresAt.isAfter(DateTime.now());
  }
}
