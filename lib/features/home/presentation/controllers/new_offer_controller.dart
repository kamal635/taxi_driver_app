import 'dart:async' show FutureOr, StreamSubscription, unawaited;

import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/presentation/parsers/new_offer_payload_parser.dart';
import 'package:bawabat_al_saeq/features/home/presentation/services/pending_offer_actionability.dart';
import 'package:bawabat_al_saeq/features/home/presentation/services/pending_offer_expiry_scheduler.dart';
import 'package:bawabat_al_saeq/features/home/presentation/state/new_offer_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

final class NewOfferController extends AsyncNotifier<NewOfferState> {
  final NewOfferPayloadParser _payloadParser = const NewOfferPayloadParser();
  final PendingOfferExpiryScheduler _expiryScheduler =
      PendingOfferExpiryScheduler();

  StreamSubscription<DriverBackgroundOfferEvent>? _offerEventsSubscription;
  StreamSubscription<DriverOfferNotificationOpenEvent>?
  _offerNotificationOpenSubscription;

  @override
  FutureOr<NewOfferState> build() {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _offerEventsSubscription ??= bridge.offerEvents.listen(
      _handleNativeOfferEvent,
    );

    _offerNotificationOpenSubscription ??= bridge.offerNotificationOpens.listen(
      _handleOfferNotificationOpened,
    );

    ref.onDispose(_disposeSubscriptions);

    return const NewOfferState();
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  void clearCurrent() {
    _expiryScheduler.cancel();
    _stopNativeOfferAlert();

    state = AsyncData(
      _currentState.copyWith(currentOffer: null, errorMessage: null),
    );
  }

  void clearError() {
    state = AsyncData(_currentState.copyWith(errorMessage: null));
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
      final offer = _payloadParser.parse(payloadJson);
      _storeOfferIfActionable(offer, source: source);
    } on Exception catch (error, stackTrace) {
      state = AsyncData(_currentState.copyWith(errorMessage: error.toString()));
      debugPrint('Failed to parse $source: $error\n$stackTrace');
    }
  }

  void _storeOfferIfActionable(
    NewOfferEntity offer, {
    required String source,
  }) {
    if (isPendingOfferExpired(offer)) {
      _handleExpiredIncomingOffer(offer, source: source);
      return;
    }

    if (hasDifferentActivePendingOffer(
      activeOffer: _currentState.currentOffer,
      incomingOffer: offer,
    )) {
      debugPrint(
        'Incoming offer ignored because another pending offer is active '
        '-> active=${_currentState.currentOffer?.offerId}, '
        'incoming=${offer.offerId}, source=$source',
      );
      return;
    }

    _expiryScheduler.schedule(
      offer: offer,
      onExpired: _expireCurrentOfferIfMatching,
    );

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

  void _expireCurrentOfferIfMatching(NewOfferEntity offer) {
    final currentOffer = state.asData?.value.currentOffer;
    if (currentOffer?.offerId != offer.offerId) return;

    _stopNativeOfferAlert();
    state = AsyncData(_currentState.copyWith(currentOffer: null));

    debugPrint('Pending offer expired locally -> id=${offer.offerId}');
  }

  void _stopNativeOfferAlert() {
    unawaited(
      ref.read(driverBackgroundServiceBridgeProvider).stopOfferAlert(),
    );
  }

  void _disposeSubscriptions() {
    unawaited(_offerEventsSubscription?.cancel());
    _offerEventsSubscription = null;

    unawaited(_offerNotificationOpenSubscription?.cancel());
    _offerNotificationOpenSubscription = null;

    _expiryScheduler.dispose();
  }
}
