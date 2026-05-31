part of '../trip_route_timeline.dart';

enum TripRouteStopType {
  pickup,
  dropoff,
}

@immutable
class TripRouteStopData {
  const TripRouteStopData({
    required this.label,
    required this.value,
    required this.type,
  });

  final String label;
  final String value;
  final TripRouteStopType type;
}
