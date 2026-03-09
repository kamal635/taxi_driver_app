import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

final class CurrentAndPendingOfferEntity {
  const CurrentAndPendingOfferEntity({
    required this.currentOffer,
    required this.pendingOffer,
  });

  final OfferAcceptedEntity? currentOffer;
  final NewOfferEntity? pendingOffer;
}
