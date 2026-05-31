import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/services/trips_commission_calculator.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/trip_amount_formatter.dart';

/// Pre-calculated display data for the commission widgets.
final class TripsCommissionViewData {
  const TripsCommissionViewData({
    required this.selectedOffers,
    required this.selectedTripsTotalText,
    required this.commissionAmountText,
  });

  factory TripsCommissionViewData.fromState({
    required List<CompletedOfferEntity> offers,
    required DateTime? fromDate,
    required DateTime? toDate,
    required String percentageText,
  }) {
    final selectedOffers = TripsCommissionCalculator.filterByDateRange(
      offers: offers,
      fromDate: fromDate,
      toDate: toDate,
    );
    final selectedTotal = TripsCommissionCalculator.totalAmount(selectedOffers);
    final percentage = TripsCommissionCalculator.parsePercentage(
      percentageText,
    );
    final commissionAmount = TripsCommissionCalculator.commissionAmount(
      totalAmount: selectedTotal,
      percentage: percentage,
    );

    return TripsCommissionViewData(
      selectedOffers: selectedOffers,
      selectedTripsTotalText: formatTripAmount(selectedTotal),
      commissionAmountText: formatTripAmount(commissionAmount),
    );
  }

  final List<CompletedOfferEntity> selectedOffers;
  final String selectedTripsTotalText;
  final String commissionAmountText;

  int get selectedTripsCount => selectedOffers.length;
}
