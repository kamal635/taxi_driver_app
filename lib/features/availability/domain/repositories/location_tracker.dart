import 'package:bawabat_al_saeq/core/location/location_result.dart';

/// Tracks runtime location-service failures needed by the availability flow.
abstract interface class LocationTracker {
  Future<void> start();
  Future<void> stop();

  Stream<LocationFailureReason> get failures;

  Future<void> dispose();
}
