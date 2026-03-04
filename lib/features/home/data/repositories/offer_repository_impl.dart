import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
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
}
