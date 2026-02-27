import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/core/location/location_service.dart';

final class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationReadyResult> ensureReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _failure(LocationFailureReason.serviceDisabled);
    }

    final current = await Geolocator.checkPermission();

    // Only request if it's "denied" (NOT deniedForever).
    final effectivePermission = (current == LocationPermission.denied)
        ? await Geolocator.requestPermission()
        : current;

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
      LocationPermission.whileInUse ||
      LocationPermission.always => LocationReadyResult.success(),

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

  LocationReadyResult _failure(
    LocationFailureReason reason, {
    String? message,
  }) {
    return LocationReadyResult.failure(reason: reason, message: message);
  }
}
