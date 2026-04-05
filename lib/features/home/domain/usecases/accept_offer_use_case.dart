import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repository.dart';

final class AcceptOfferUseCase {
  AcceptOfferUseCase({required this.offerRepository});

  final OfferRepository offerRepository;

  Future<OfferAcceptedEntity> call({required String offerId}) {
    return offerRepository.acceptOffer(offerId: offerId);
  }
}
