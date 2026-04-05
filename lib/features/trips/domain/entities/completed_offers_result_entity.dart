import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';

/// Available filters for completed trips.
enum CompletedPeriod {
  all,
  day,
  week,
  month,
}

/// Domain entity for the completed trips screen payload.
final class CompletedOffersResultEntity {
  CompletedOffersResultEntity({
    required this.type,
    required this.period,
    required this.count,
    required this.totalProfits,
    required this.offers,
  });

  final String type;
  final CompletedPeriod period;
  final int count;
  final String totalProfits;
  final List<CompletedOfferEntity> offers;
}
