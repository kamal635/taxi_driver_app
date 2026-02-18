import 'package:flutter/foundation.dart';

@immutable
class TripUi {
  const TripUi({
    required this.placeTitle,
    required this.timeText,
    required this.fareText,
  });

  final String placeTitle;
  final String timeText;
  final String fareText;
}
