import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

class DeclineOfferUseCase {
  const DeclineOfferUseCase(this._repo);
  final OfferRepository _repo;

  Future<void> call({required String offeroId}) {
    return _repo.declineOffer(offeroId: offeroId);
  }
}
