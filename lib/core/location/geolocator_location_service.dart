import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/core/location/location_service.dart';

final class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationReadyResult> ensureReady() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return _failure(LocationFailureReason.serviceDisabled);
    }

    final currentPermission = await Geolocator.checkPermission();
    final effectivePermission = currentPermission == LocationPermission.denied
        ? await Geolocator.requestPermission()
        : currentPermission;

    return _resultFromPermission(effectivePermission);
  }

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  LocationReadyResult _resultFromPermission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse => LocationReadyResult.success(),
      LocationPermission.denied => _failure(
        LocationFailureReason.permissionDenied,
      ),
      LocationPermission.deniedForever => _failure(
        LocationFailureReason.permissionDeniedForever,
      ),
      LocationPermission.unableToDetermine => _failure(
        LocationFailureReason.unableToDetermine,
      ),
    };
  }

  LocationReadyResult _failure(LocationFailureReason reason) {
    return LocationReadyResult.failure(reason: reason);
  }
}
