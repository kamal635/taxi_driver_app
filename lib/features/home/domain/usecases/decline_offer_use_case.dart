import 'package:taxi_driver_app/features/home/domain/repositories/offer_repository.dart';

final class DeclineOfferUseCase {
  const DeclineOfferUseCase(this._offerRepository);

  final OfferRepository _offerRepository;

  Future<void> call({required String offerId}) {
    return _offerRepository.declineOffer(offerId: offerId);
  }
}
