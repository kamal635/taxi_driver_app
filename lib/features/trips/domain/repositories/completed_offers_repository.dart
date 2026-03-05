import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

abstract interface class CompletedOffersRepository {
  Future<CompletedOffersResultEntity> getCompletedOffers({
    required CompletedPeriod period,
  });
}
