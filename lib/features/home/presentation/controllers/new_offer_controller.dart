import 'dart:async' show FutureOr, StreamSubscription, Timer, unawaited;
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

// Provides the pending offer controller fed by native background events.
final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

final class NewOfferController extends AsyncNotifier<NewOfferState> {
  StreamSubscription<DriverBackgroundOfferEvent>? _offerEventsSub;
  StreamSubscription<DriverOfferNotificationOpenEvent>?
  _offerNotificationOpensSub;

  Timer? _expiryTimer;

  @override
  FutureOr<NewOfferState> build() {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _offerEventsSub ??= bridge.offerEvents.listen(
      _handleNativeOfferEvent,
    );

    _offerNotificationOpensSub ??= bridge.offerNotificationOpens.listen(
      _handleOfferNotificationOpened,
    );

    ref.onDispose(() {
      unawaited(_offerEventsSub?.cancel());
      _offerEventsSub = null;

      unawaited(_offerNotificationOpensSub?.cancel());
      _offerNotificationOpensSub = null;

      _cancelExpiryTimer();
    });

    return const NewOfferState();
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  void clearCurrent() {
    _cancelExpiryTimer();

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
    } on Exception catch (e, st) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: e.toString()),
      );

      debugPrint('Failed to parse native background offer: $e\n$st');
    }
  }

  void _handleOfferNotificationOpened(
    DriverOfferNotificationOpenEvent event,
  ) {
    debugPrint(
      'Offer notification opened -> offerId=${event.offerId}',
    );

    final payloadJson = event.payloadJson;
    if (payloadJson == null || payloadJson.isEmpty) {
      debugPrint('Offer notification open ignored: missing payloadJson');
      return;
    }

    try {
      final offer = _parseOfferFromPayload(payloadJson);
      _storeOfferIfActive(offer);
    } on Exception catch (e, st) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: e.toString()),
      );

      debugPrint('Failed to restore offer from notification open: $e\n$st');
    }
  }

  NewOfferEntity _parseOfferFromPayload(String payloadJson) {
    final decoded = jsonDecode(payloadJson);

    if (decoded is! Map) {
      throw const FormatException(
        'Offer payload is not a JSON object.',
      );
    }

    final json = Map<String, dynamic>.from(decoded);
    final model = NewOfferModel.fromJson(json);

    return _mapToEntity(model);
  }

  void _storeOfferIfActive(NewOfferEntity offer) {
    _cancelExpiryTimer();

    if (_isExpired(offer)) {
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

      state = AsyncData(
        _currentState.copyWith(currentOffer: null),
      );

      debugPrint(
        'Pending offer expired locally -> id=${offer.offerId}',
      );
    });
  }

  void _cancelExpiryTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  bool _isExpired(NewOfferEntity offer) {
    return !offer.expiresAt.isAfter(DateTime.now());
  }

  NewOfferEntity _mapToEntity(NewOfferModel model) {
    return NewOfferEntity(
      type: model.type,
      offerId: model.offerId,
      pickup: model.pickup,
      price: model.price,
      expiresAt: model.expiresAt,
      dropoff: model.dropoff,
      notes: model.notes,
    );
  }
}

@immutable
final class NewOfferState {
  const NewOfferState({
    this.currentOffer,
    this.errorMessage,
  });

  final NewOfferEntity? currentOffer;
  final String? errorMessage;

  static const Object _unset = Object();

  NewOfferState copyWith({
    Object? currentOffer = _unset,
    Object? errorMessage = _unset,
  }) {
    return NewOfferState(
      currentOffer: identical(currentOffer, _unset)
          ? this.currentOffer
          : currentOffer as NewOfferEntity?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
