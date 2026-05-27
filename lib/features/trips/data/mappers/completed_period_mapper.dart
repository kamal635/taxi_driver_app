import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Maps backend period values to domain values and vice versa.
CompletedPeriod completedPeriodFromJson(Object? value) {
  final rawValue = (value ?? 'all').toString().trim().toLowerCase();

  return switch (rawValue) {
    'day' || 'today' => CompletedPeriod.day,
    'week' || 'weekly' => CompletedPeriod.week,
    'month' || 'monthly' => CompletedPeriod.month,
    _ => CompletedPeriod.all,
  };
}

String completedPeriodToQuery(CompletedPeriod period) {
  return switch (period) {
    CompletedPeriod.all => 'all',
    CompletedPeriod.day => 'day',
    CompletedPeriod.week => 'week',
    CompletedPeriod.month => 'month',
  };
}
