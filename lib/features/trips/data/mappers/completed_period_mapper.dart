import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

CompletedPeriod completedPeriodFromJson(Object? value) {
  final v = (value ?? 'all').toString();

  switch (v) {
    case 'all':
      return CompletedPeriod.all;
    case 'month':
      return CompletedPeriod.month;
    case 'week':
      return CompletedPeriod.week;
    case 'day':
      return CompletedPeriod.day;
    default:
      return CompletedPeriod.all; // fallback
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
