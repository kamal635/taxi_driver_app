import 'package:flutter/material.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

/// Formats completed trip time labels for the trips list.
class CompletedTripTimeFormatter {
  const CompletedTripTimeFormatter._();

  static String format(BuildContext context, DateTime dateTime) {
    final l10n = context.l10n;
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final tripDayStart = DateTime(
      localDateTime.year,
      localDateTime.month,
      localDateTime.day,
    );

    final dayDifference = todayStart.difference(tripDayStart).inDays;

    final materialLocalizations = MaterialLocalizations.of(context);
    final timeText = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDateTime),
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    if (dayDifference == 0) {
      return '${l10n.todayLabel} $timeText';
    }

    if (dayDifference == 1) {
      return '${l10n.yesterdayLabel} $timeText';
    }

    if (dayDifference > 1 && dayDifference < 7) {
      final weekdayLabel = _weekdayLabel(
        weekday: localDateTime.weekday,
        context: context,
      );
      return '$weekdayLabel $timeText';
    }

    final dateText = materialLocalizations.formatShortDate(localDateTime);
    return '$dateText $timeText';
  }

  static String _weekdayLabel({
    required int weekday,
    required BuildContext context,
  }) {
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
