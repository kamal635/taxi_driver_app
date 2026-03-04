import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class AccepteOfferUsecase {
  AccepteOfferUsecase({required this.offerRepository});

  final OfferRepository offerRepository;

  Future<OfferAcceptedEntity> call({required String offeroId}) async {
    return offerRepository.accepteOfer(offeroId: offeroId);
  }
}
