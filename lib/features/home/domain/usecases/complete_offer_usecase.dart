import 'package:taxi_driver_app/features/home/domain/entities/complete_offer_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class CompleteOfferUseCase {
  CompleteOfferUseCase({required this.repo});

  final OfferRepository repo;

  Future<CompleteOfferResultEntity> call({required String offerId}) {
    return repo.completeOffer(offerId: offerId);
  }
}
