import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class GetCurrentAndPendingOfferUsecase {
  GetCurrentAndPendingOfferUsecase({required this.repo});

  final OfferRepository repo;

  Future<CurrentAndPendingOfferEntity?> call() {
    return repo.getCurrentAndPendingOffer();
  }
}
