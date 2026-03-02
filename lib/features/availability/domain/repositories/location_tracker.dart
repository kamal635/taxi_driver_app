import 'package:taxi_driver_app/core/location/location_result.dart';

abstract interface class LocationTracker {
  Future<void> start();
  Future<void> stop();
  Stream<LocationFailureReason> get failures;

  void dispose();
}
