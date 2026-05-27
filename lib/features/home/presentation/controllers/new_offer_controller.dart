import 'dart:async' show FutureOr, StreamSubscription, Timer, unawaited;
import 'dart:convert';

import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_model.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/presentation/state/new_offer_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

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
      _currentState.copyWith(currentOffer: null, errorMessage: null),
    );
  }

  void clearError() {
    state = AsyncData(
      _currentState.copyWith(errorMessage: null),
    );
  }

  void restoreFromNotificationPayload(String payloadJson) {
    _handleIncomingOfferPayload(
      payloadJson,
      source: 'notification payload',
    );
  }

  void _handleNativeOfferEvent(DriverBackgroundOfferEvent event) {
    _handleIncomingOfferPayload(
      event.payloadJson,
      source: 'native background offer',
    );
  }

  void _handleOfferNotificationOpened(
    DriverOfferNotificationOpenEvent event,
  ) {
    debugPrint('Offer notification opened -> offerId=${event.offerId}');

    final payloadJson = event.payloadJson;
    if (payloadJson == null || payloadJson.isEmpty) {
      debugPrint('Offer notification open ignored: missing payloadJson');
      return;
    }

    restoreFromNotificationPayload(payloadJson);
  }

  void _handleIncomingOfferPayload(
    String payloadJson, {
    required String source,
  }) {
    try {
      final offer = _parseOfferFromPayload(payloadJson);
      _storeOfferIfActionable(offer, source: source);
    } on Exception catch (error, stackTrace) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: error.toString()),
      );

      debugPrint('Failed to parse $source: $error\n$stackTrace');
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

  void _storeOfferIfActionable(
    NewOfferEntity offer, {
    required String source,
  }) {
    if (_isExpired(offer)) {
      _handleExpiredIncomingOffer(offer, source: source);
      return;
    }

    final activeOffer = _currentState.currentOffer;
    final hasDifferentActiveOffer =
        activeOffer != null &&
        activeOffer.offerId != offer.offerId &&
        !_isExpired(activeOffer);

    if (hasDifferentActiveOffer) {
      debugPrint(
        'Incoming offer ignored because another pending offer is active '
        '-> active=${activeOffer.offerId}, incoming=${offer.offerId}, '
        'source=$source',
      );
      return;
    }

    _cancelExpiryTimer();
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

  void _handleExpiredIncomingOffer(
    NewOfferEntity offer, {
    required String source,
  }) {
    final activeOffer = _currentState.currentOffer;
    if (activeOffer?.offerId == offer.offerId) {
      clearCurrent();
    } else {
      _stopNativeOfferAlert();
    }

    debugPrint(
      'Ignoring expired offer -> id=${offer.offerId}, source=$source',
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
