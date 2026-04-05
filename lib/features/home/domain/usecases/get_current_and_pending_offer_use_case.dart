import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repository.dart';

final class GetCurrentAndPendingOfferUseCase {
  GetCurrentAndPendingOfferUseCase({required this.offerRepository});

  final OfferRepository offerRepository;

  Future<CurrentAndPendingOfferEntity?> call() {
    return offerRepository.getCurrentAndPendingOffer();
  }
}
