import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

bool isPendingOfferExpired(NewOfferEntity offer) {
  return !offer.expiresAt.isAfter(DateTime.now());
}

bool hasDifferentActivePendingOffer({
  required NewOfferEntity? activeOffer,
  required NewOfferEntity incomingOffer,
}) {
  return activeOffer != null &&
      activeOffer.offerId != incomingOffer.offerId &&
      !isPendingOfferExpired(activeOffer);
}
