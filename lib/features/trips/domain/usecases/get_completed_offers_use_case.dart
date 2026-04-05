import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';

/// Loads completed trips for the selected period.
final class GetCompletedOffersUseCase {
  GetCompletedOffersUseCase({
    required this.repository,
  });

  final CompletedOffersRepository repository;

  Future<CompletedOffersResultEntity> call({
    required CompletedPeriod period,
  }) {
    return repository.getCompletedOffers(period: period);
  }
}
