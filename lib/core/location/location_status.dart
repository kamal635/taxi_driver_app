import 'package:bawabat_al_saeq/core/location/location_result.dart';

/// App-level permission status
///  used by the UI without exposing Geolocator types.
enum AppLocationPermissionStatus {
  /// The user has not granted location access yet, but the app may ask again.
  denied,

  /// The user denied location access
  /// permanently and must enable it from settings.
  deniedForever,

  /// The app can access location only while it is in use.
  whileInUse,

  /// The app can access location while in use and in the background.
  always,

  /// The platform could not determine the permission state.
  unableToDetermine,
}

final class LocationStatus {
  const LocationStatus({
    required this.isServiceEnabled,
    required this.permissionStatus,
  });

  final bool isServiceEnabled;
  final AppLocationPermissionStatus permissionStatus;

  bool get hasForegroundPermission {
    return switch (permissionStatus) {
      AppLocationPermissionStatus.whileInUse ||
      AppLocationPermissionStatus.always => true,
      AppLocationPermissionStatus.denied ||
      AppLocationPermissionStatus.deniedForever ||
      AppLocationPermissionStatus.unableToDetermine => false,
    };
  }

  bool get hasBackgroundPermission {
    return permissionStatus == AppLocationPermissionStatus.always;
  }

  bool get isReady {
    return isServiceEnabled && hasForegroundPermission;
  }

  bool get isFullyReadyForBackgroundTracking {
    return isServiceEnabled &&
        hasForegroundPermission &&
        hasBackgroundPermission;
  }

  LocationReadyResult toReadyResult({bool requireBackground = false}) {
    if (!isServiceEnabled) {
      return LocationReadyResult.failure(
        reason: LocationFailureReason.serviceDisabled,
      );
    }

    if (!hasForegroundPermission) {
      return LocationReadyResult.failure(
        reason: switch (permissionStatus) {
          AppLocationPermissionStatus.denied =>
            LocationFailureReason.permissionDenied,
          AppLocationPermissionStatus.deniedForever =>
            LocationFailureReason.permissionDeniedForever,
          AppLocationPermissionStatus.unableToDetermine =>
            LocationFailureReason.unableToDetermine,
          AppLocationPermissionStatus.whileInUse ||
          AppLocationPermissionStatus.always =>
            LocationFailureReason.unableToDetermine,
        },
      );
    }

    if (requireBackground && !hasBackgroundPermission) {
      return LocationReadyResult.failure(
        reason: LocationFailureReason.backgroundPermissionRequired,
      );
    }

    return LocationReadyResult.success();
  }
}
