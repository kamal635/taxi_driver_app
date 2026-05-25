import 'package:bawabat_al_saeq/features/home/data/datasources/remote/offer_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/complete_offer_result_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/repositories/offer_repository.dart';

/// Repository implementation that maps remote models into domain entities.
final class OfferRepositoryImpl implements OfferRepository {
  OfferRepositoryImpl({required this.remoteDataSource});

  final OfferRemoteDataSource remoteDataSource;

  @override
  Future<OfferAcceptedEntity> acceptOffer({required String offerId}) async {
    final model = await remoteDataSource.acceptOffer(offerId: offerId);
    return model.toEntity();
  }

  @override
  Future<void> declineOffer({required String offerId}) {
    return remoteDataSource.declineOffer(offerId: offerId);
  }

  @override
  Future<CurrentAndPendingOfferEntity?> getCurrentAndPendingOffer() async {
    final model = await remoteDataSource.getCurrentAndPendingOffer();
    return model?.toEntity();
  }

  @override
  Future<CompleteOfferResultEntity> completeOffer({
    required String offerId,
  }) async {
    final model = await remoteDataSource.completeOffer(offerId: offerId);
    return model.toEntity();
  }
}
