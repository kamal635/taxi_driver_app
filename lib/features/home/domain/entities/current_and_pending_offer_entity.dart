import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:flutter/foundation.dart';

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
