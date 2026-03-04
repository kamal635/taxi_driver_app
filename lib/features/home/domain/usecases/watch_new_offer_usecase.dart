import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class WatchNewOfferUseCase {
  WatchNewOfferUseCase({required this.offerRepository});

  final OfferRepository offerRepository;

  Stream<NewOfferEntity> call() {
    return offerRepository.watchOffer();
  }
}
