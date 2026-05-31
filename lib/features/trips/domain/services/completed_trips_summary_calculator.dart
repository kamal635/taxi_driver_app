import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/trip_amount_formatter.dart';

/// Pure calculations used by the completed trips screen.
///
/// Keeping this outside widgets makes
///  rebuilds cheaper and keeps UI files small.
abstract final class CompletedTripsSummaryCalculator {
  const CompletedTripsSummaryCalculator._();

  static num totalAmount(List<CompletedOfferEntity> offers) {
    return offers.fold<num>(
      0,
      (total, offer) => total + parseTripAmount(offer.price),
    );
  }

  static num averageAmount({
    required num totalAmount,
    required int count,
  }) {
    if (count <= 0) return 0;
    return totalAmount / count;
  }
}
