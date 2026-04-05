import 'package:taxi_driver_app/features/trips/data/datasources/remote/completed_offers_remote_data_source.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';

/// Repository implementation that maps remote models into domain entities.
final class CompletedOffersRepositoryImpl implements CompletedOffersRepository {
  CompletedOffersRepositoryImpl({
    required this.remoteDataSource,
  });

  final CompletedOffersRemoteDataSource remoteDataSource;

  @override
  Future<CompletedOffersResultEntity> getCompletedOffers({
    required CompletedPeriod period,
  }) async {
    final result = await remoteDataSource.getCompletedOffers(period: period);
    return result.toEntity();
  }
}
