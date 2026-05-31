import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_period.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';

/// Periods shown in the trips filter UI.
const tripsVisiblePeriods = <CompletedPeriod>[
  CompletedPeriod.all,
  CompletedPeriod.day,
  CompletedPeriod.week,
  CompletedPeriod.month,
];

extension CompletedPeriodX on CompletedPeriod {
  String label(AppLocalizations l10n) {
    return switch (this) {
      CompletedPeriod.all => l10n.tripsFilterAll,
      CompletedPeriod.day => l10n.tripsFilterToday,
      CompletedPeriod.week => l10n.tripsFilterLast7Days,
      CompletedPeriod.month => l10n.tripsFilterThisMonth,
    };
  }
}
