import 'package:taxi_driver_app/features/trips/data/datasources/completed_offers_remote_data_source.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';

final class CompletedOffersRepoImpl implements CompletedOffersRepository {
  CompletedOffersRepoImpl({required this.remote});

  final CompletedOffersRemoteDataSource remote;
  @override
  Future<CompletedOffersResultEntity> getCompletedOffers({
    required CompletedPeriod period,
  }) async {
    final result = await remote.getCompletedOffers(period: period);

    return result.toEntity();
  }
}
