import 'package:flutter/widgets.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

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
