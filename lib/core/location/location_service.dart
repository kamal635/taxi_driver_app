import 'package:taxi_driver_app/core/location/location_result.dart';

abstract interface class LocationService {
  Future<LocationReadyResult> ensureReady();

  /// Opens the system Location Services settings (GPS).
  Future<bool> openLocationSettings();

  /// Opens this app's settings page.
  Future<bool> openAppSettings();
}
