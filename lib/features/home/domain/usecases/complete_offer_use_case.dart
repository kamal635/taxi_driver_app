import 'package:taxi_driver_app/features/home/domain/entities/complete_offer_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repository.dart';

final class CompleteOfferUseCase {
  CompleteOfferUseCase({required this.offerRepository});

  final OfferRepository offerRepository;

  Future<CompleteOfferResultEntity> call({required String offerId}) {
    return offerRepository.completeOffer(offerId: offerId);
  }
}
