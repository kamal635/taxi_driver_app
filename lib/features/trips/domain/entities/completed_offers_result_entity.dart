import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_period.dart';

/// Domain entity for the completed trips screen payload.
final class CompletedOffersResultEntity {
  const CompletedOffersResultEntity({
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
