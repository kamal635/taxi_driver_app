import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/core/location/location_service.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:geolocator/geolocator.dart';

final class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationStatus> checkStatus() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();

    return LocationStatus(
      isServiceEnabled: isServiceEnabled,
      permissionStatus: _statusFromPermission(permission),
    );
  }

  @override
  Future<LocationReadyResult> ensureReady({
    bool requireBackground = false,
  }) async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return _failure(LocationFailureReason.serviceDisabled);
    }

    final currentPermission = await Geolocator.checkPermission();
    final effectivePermission = currentPermission == LocationPermission.denied
        ? await Geolocator.requestPermission()
        : currentPermission;

    final status = LocationStatus(
      isServiceEnabled: isServiceEnabled,
      permissionStatus: _statusFromPermission(effectivePermission),
    );

    return status.toReadyResult(requireBackground: requireBackground);
  }

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  AppLocationPermissionStatus _statusFromPermission(
    LocationPermission permission,
  ) {
    return switch (permission) {
      LocationPermission.denied => AppLocationPermissionStatus.denied,
      LocationPermission.deniedForever =>
        AppLocationPermissionStatus.deniedForever,
      LocationPermission.whileInUse => AppLocationPermissionStatus.whileInUse,
      LocationPermission.always => AppLocationPermissionStatus.always,
      LocationPermission.unableToDetermine =>
        AppLocationPermissionStatus.unableToDetermine,
    };
  }

  LocationReadyResult _failure(LocationFailureReason reason) {
    return LocationReadyResult.failure(reason: reason);
  }
}
