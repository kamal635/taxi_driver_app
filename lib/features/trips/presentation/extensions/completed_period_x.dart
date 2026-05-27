import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';

extension CompletedPeriodX on CompletedPeriod {
  String label(AppLocalizations l10n) {
    return switch (this) {
      CompletedPeriod.all => l10n.tripsFilterAll,
      CompletedPeriod.day => l10n.tripsFilterToday,
      CompletedPeriod.week => l10n.tripsFilterWeek,
      CompletedPeriod.month => l10n.month,
    };
  }
}
