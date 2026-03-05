import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';

final class GetCompletedOffersUseCase {
  GetCompletedOffersUseCase({required this.repo});

  final CompletedOffersRepository repo;

  Future<CompletedOffersResultEntity> call({
    required CompletedPeriod period,
  }) {
    return repo.getCompletedOffers(period: period);
  }
}
