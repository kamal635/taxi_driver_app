import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/trip_amount_formatter.dart';

/// Pure commission/date-range calculations for completed trips.
abstract final class TripsCommissionCalculator {
  const TripsCommissionCalculator._();

  static List<CompletedOfferEntity> filterByDateRange({
    required List<CompletedOfferEntity> offers,
    required DateTime? fromDate,
    required DateTime? toDate,
  }) {
    if (fromDate == null && toDate == null) return offers;

    final normalizedFromDate = dateOnly(fromDate);
    final normalizedToDate = endOfDay(toDate);

    return offers
        .where((offer) {
          final tripDate = offer.updatedAt;
          final isAfterStart =
              normalizedFromDate == null ||
              !tripDate.isBefore(normalizedFromDate);
          final isBeforeEnd =
              normalizedToDate == null || !tripDate.isAfter(normalizedToDate);

          return isAfterStart && isBeforeEnd;
        })
        .toList(growable: false);
  }

  static num totalAmount(List<CompletedOfferEntity> offers) {
    return offers.fold<num>(
      0,
      (total, offer) => total + parseTripAmount(offer.price),
    );
  }

  static num parsePercentage(String rawValue) {
    final normalized = rawValue.trim().replaceAll(',', '.');
    final percentage = num.tryParse(normalized);

    if (percentage == null || percentage.isNaN || percentage.isInfinite) {
      return 0;
    }

    if (percentage < 0) return 0;
    if (percentage > 100) return 100;

    return percentage;
  }

  static num commissionAmount({
    required num totalAmount,
    required num percentage,
  }) {
    return totalAmount * (percentage / 100);
  }

  static DateTime? dateOnly(DateTime? value) {
    if (value == null) return null;
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime? endOfDay(DateTime? value) {
    if (value == null) return null;
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  }
}
