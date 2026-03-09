import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
import 'package:taxi_driver_app/features/home/domain/entities/complete_order_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class OfferRepositoryImpl implements OfferRepository {
  OfferRepositoryImpl({required this.remote});

  final OfferRemoteDatasource remote;
  @override
  Stream<NewOfferEntity> watchOffer() {
    return remote.watchOffer().map((m) => m.toEntity());
  }

  @override
  Future<OfferAcceptedEntity> accepteOfer({required String offeroId}) async {
    final data = await remote.accepteOffer(offeroId: offeroId);

    return data.toEntity();
  }

  @override
  Future<void> declineOffer({required String offeroId}) async {
    await remote.declineOffer(offeroId: offeroId);
  }

  @override
  Future<CurrentAndPendingOfferEntity?> getCurrentAndPendingOffer() async {
    final res = await remote.getCurrentAndPendingOffer();

    return CurrentAndPendingOfferEntity(
      currentOffer: res?.currentOffer?.toEntity(),
      pendingOffer: res?.pendingOffer?.toEntity(),
    );
  }

  @override
  Future<CompleteOrderResultEntity> completeOrder({
    required String orderId,
  }) async {
    final res = await remote.completeOrder(orderId: orderId);
    return res.toEntity();
  }
}
