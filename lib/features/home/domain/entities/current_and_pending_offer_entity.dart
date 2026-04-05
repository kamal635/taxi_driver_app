import 'package:flutter/foundation.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

@immutable
final class CurrentAndPendingOfferEntity {
  const CurrentAndPendingOfferEntity({
    required this.currentOffer,
    required this.pendingOffer,
  });

  const CurrentAndPendingOfferEntity.empty()
    : currentOffer = null,
      pendingOffer = null;

  final OfferAcceptedEntity? currentOffer;
  final NewOfferEntity? pendingOffer;
}
