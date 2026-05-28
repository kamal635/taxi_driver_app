import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';

/// Periods shown in the trips filter UI.
///
/// The backend still supports [CompletedPeriod.all], but the driver-facing
/// screen intentionally focuses on the three useful operational filters.
const tripsVisiblePeriods = <CompletedPeriod>[
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
