import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Contract for completed trips data access.
abstract interface class CompletedOffersRepository {
  Future<CompletedOffersResultEntity> getCompletedOffers({
    required CompletedPeriod period,
  });
}
