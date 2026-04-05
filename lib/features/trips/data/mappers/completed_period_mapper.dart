import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Maps backend period values to domain values and vice versa.
CompletedPeriod completedPeriodFromJson(Object? value) {
  final rawValue = (value ?? 'all').toString();

  switch (rawValue) {
    case 'all':
      return CompletedPeriod.all;
    case 'month':
      return CompletedPeriod.month;
    case 'week':
      return CompletedPeriod.week;
    case 'day':
      return CompletedPeriod.day;
    default:
      return CompletedPeriod.all;
  }
}

String completedPeriodToQuery(CompletedPeriod period) {
  return switch (period) {
    CompletedPeriod.all => 'all',
    CompletedPeriod.month => 'month',
    CompletedPeriod.week => 'week',
    CompletedPeriod.day => 'day',
  };
}
