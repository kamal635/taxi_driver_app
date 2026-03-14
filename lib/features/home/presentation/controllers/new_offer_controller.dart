import 'dart:async' show FutureOr, StreamSubscription, unawaited;
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
    });

    final result = await ref.watch(currentAndPendingOfferProvider.future);
    final pendingOffer = result?.pendingOffer;

    return NewOfferState(currentOffer: pendingOffer);
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  // Clear the currently stored pending offer.
  void clearCurrent() {
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

      state = AsyncData(
        _currentState.copyWith(
          currentOffer: offer,
          errorMessage: null,
        ),
      );

      debugPrint(
        'Native background offer stored successfully -> id=${offer.offerId}',
      );
    } on Exception catch (e, st) {
      state = AsyncData(
        _currentState.copyWith(errorMessage: e.toString()),
      );

      debugPrint('Failed to parse native background offer: $e\n$st');
    }
  }

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
