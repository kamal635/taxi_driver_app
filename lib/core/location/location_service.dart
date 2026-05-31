import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';

abstract interface class LocationService {
  /// Reads the current location service and
  ///  permission status without prompting.
  Future<LocationStatus> checkStatus();

  /// Ensures that location services and permissions are ready to use.
  Future<LocationReadyResult> ensureReady({bool requireBackground = false});

  /// Opens the system location services settings screen.
  Future<bool> openLocationSettings();

  /// Opens this app's settings screen.
  Future<bool> openAppSettings();
}
