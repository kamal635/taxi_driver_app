import 'dart:async' show FutureOr, StreamSubscription, Timer, unawaited;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

// Provides the pending offer controller fed by native background events.
final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

final class NewOfferController extends AsyncNotifier<NewOfferState> {
  StreamSubscription<DriverBackgroundOfferEvent>? _offerEventsSub;
  Timer? _expiryTimer;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  FutureOr<NewOfferState> build() async {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _offerEventsSub ??= bridge.offerEvents.listen(
      _handleNativeOfferEvent,
    );

    ref.onDispose(() {
      unawaited(_offerEventsSub?.cancel());
      _offerEventsSub = null;

      _expiryTimer?.cancel();
      _expiryTimer = null;
    });

    final result = await ref.watch(currentAndPendingOfferProvider.future);
    final pendingOffer = _prepareInitialOffer(result?.pendingOffer);

    return NewOfferState(currentOffer: pendingOffer);
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  // Clear the currently stored pending offer.
  void clearCurrent() {
    _cancelExpiryTimer();

    state = AsyncData(
      _currentState.copyWith(currentOffer: null),
    );
  }

  // Clear the last visible parsing error.
  void clearError() {
    state = AsyncData(
      _currentState.copyWith(errorMessage: null),
    );
  }

  // ---------------------------------------------------------------------------
  // Native offer events
  // ---------------------------------------------------------------------------

  // Handle incoming native offer events from the Android background service.
  void _handleNativeOfferEvent(DriverBackgroundOfferEvent event) {
    try {
      final decoded = jsonDecode(event.payloadJson);

      if (decoded is! Map) {
        throw const FormatException(
          'Native offer payload is not a JSON object.',
        );
      }

      final json = Map<String, dynamic>.from(decoded);
      final model = NewOfferModel.fromJson(json);
      final offer = _mapToEntity(model);

      _storeOfferIfActive(offer);
    } on Exception catch (e, st) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: e.toString()),
      );

      debugPrint('Failed to parse native background offer: $e\n$st');
    }
  }

  // ---------------------------------------------------------------------------
  // Offer expiry
  // ---------------------------------------------------------------------------

  // Prepare the initial pending offer loaded from backend state.
  NewOfferEntity? _prepareInitialOffer(NewOfferEntity? offer) {
    _cancelExpiryTimer();

    if (offer == null) return null;

    if (_isExpired(offer)) {
      debugPrint(
        'Skipping expired initial pending offer -> id=${offer.offerId}',
      );
      return null;
    }

    _scheduleExpiryTimer(offer);
    return offer;
  }

  // Store a new offer only if it is still active.
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

  // Schedule automatic removal when the offer expires.
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

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  // Map the data model to a presentation-ready domain entity.
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
