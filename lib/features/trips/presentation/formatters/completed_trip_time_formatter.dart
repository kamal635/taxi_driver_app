import 'package:flutter/material.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class CompletedTripTimeFormatter {
  const CompletedTripTimeFormatter._();

  // Format completed trip time for the list item.
  static String format(BuildContext context, DateTime dateTime) {
    final l10n = context.l10n;
    final local = dateTime.toLocal();
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final tripDayStart = DateTime(local.year, local.month, local.day);

    final daysDifference = todayStart.difference(tripDayStart).inDays;

    final material = MaterialLocalizations.of(context);
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    if (daysDifference == 0) {
      return '${l10n.todayLabel} $timeText';
    }

    if (daysDifference == 1) {
      return '${l10n.yesterdayLabel} $timeText';
    }

    if (daysDifference > 1 && daysDifference < 7) {
      final weekdayText = _weekdayLabel(local.weekday, context);
      return '$weekdayText $timeText';
    }

    final dateText = material.formatShortDate(local);
    return '$dateText $timeText';
  }

  // Map weekday to localized label.
  static String _weekdayLabel(int weekday, BuildContext context) {
    final l10n = context.l10n;

    switch (weekday) {
      case DateTime.monday:
        return l10n.weekdayMonday;
      case DateTime.tuesday:
        return l10n.weekdayTuesday;
      case DateTime.wednesday:
        return l10n.weekdayWednesday;
      case DateTime.thursday:
        return l10n.weekdayThursday;
      case DateTime.friday:
        return l10n.weekdayFriday;
      case DateTime.saturday:
        return l10n.weekdaySaturday;
      case DateTime.sunday:
        return l10n.weekdaySunday;
      default:
        return '';
    }
  }
}
