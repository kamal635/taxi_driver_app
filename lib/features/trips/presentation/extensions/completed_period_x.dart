import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

extension CompletedPeriodX on CompletedPeriod {
  String label(AppLocalizations l10n) {
    return switch (this) {
      CompletedPeriod.all => l10n.all,
      CompletedPeriod.day => l10n.day,
      CompletedPeriod.week => l10n.week,
      CompletedPeriod.month => l10n.month,
    };
  }
}
