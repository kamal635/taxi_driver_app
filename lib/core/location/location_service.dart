import 'package:taxi_driver_app/core/location/location_result.dart';

abstract interface class LocationService {
  /// Ensures that location services and permissions are ready to use.
  Future<LocationReadyResult> ensureReady();

  /// Opens the system location services settings screen.
  Future<bool> openLocationSettings();

  /// Opens this app's settings screen.
  Future<bool> openAppSettings();
}
