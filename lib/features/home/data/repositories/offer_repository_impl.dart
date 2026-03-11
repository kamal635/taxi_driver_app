import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
import 'package:taxi_driver_app/features/home/domain/entities/complete_offer_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class OfferRepositoryImpl implements OfferRepository {
  OfferRepositoryImpl({required this.remote});

  final OfferRemoteDatasource remote;

  ///  1- watch new Offer
  @override
  Stream<NewOfferEntity> watchOffer() {
    return remote.watchOffer().map((m) => m.toEntity());
  }

  ///  2- accepte Offer
  @override
  Future<OfferAcceptedEntity> accepteOffer({required String offerId}) async {
    final data = await remote.accepteOffer(offerId: offerId);

    return data.toEntity();
  }

  ///  3- decline Offer
  @override
  Future<void> declineOffer({required String offerId}) async {
    await remote.declineOffer(offerId: offerId);
  }

  ///  4- get Current And Pending Offer
  @override
  Future<CurrentAndPendingOfferEntity?> getCurrentAndPendingOffer() async {
    final res = await remote.getCurrentAndPendingOffer();

    return CurrentAndPendingOfferEntity(
      currentOffer: res?.currentOffer?.toEntity(),
      pendingOffer: res?.pendingOffer?.toEntity(),
    );
  }

  ///  5- decline Offer
  @override
  Future<CompleteOfferResultEntity> completeOffer({
    required String offerId,
  }) async {
    final res = await remote.completeOffer(offerId: offerId);
    return res.toEntity();
  }
}
