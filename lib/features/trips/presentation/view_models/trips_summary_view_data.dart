import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/services/completed_trips_summary_calculator.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/trip_amount_formatter.dart';

/// Pre-calculated display data for the summary card.
final class TripsSummaryViewData {
  const TripsSummaryViewData({
    required this.offers,
    required this.tripsCount,
    required this.totalProfitsText,
    required this.averageFareText,
  });

  factory TripsSummaryViewData.fromResult(
    CompletedOffersResultEntity? result,
  ) {
    final offers = result?.offers ?? const <CompletedOfferEntity>[];
    final tripsCount = result?.count ?? offers.length;
    final totalProfitsValue = parseTripAmount(result?.totalProfits ?? '0');
    final averageFareValue = CompletedTripsSummaryCalculator.averageAmount(
      totalAmount: totalProfitsValue,
      count: tripsCount,
    );

    return TripsSummaryViewData(
      offers: offers,
      tripsCount: tripsCount,
      totalProfitsText: formatTripAmount(totalProfitsValue),
      averageFareText: formatTripAmount(averageFareValue),
    );
  }

  final List<CompletedOfferEntity> offers;
  final int tripsCount;
  final String totalProfitsText;
  final String averageFareText;
}
