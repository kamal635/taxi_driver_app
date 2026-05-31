enum LocationFailureReason {
  /// GPS or location services are turned off on the device.
  serviceDisabled,

  /// Permission is denied, but the app may ask again.
  permissionDenied,

  /// Permission is denied forever and must be enabled from settings.
  permissionDeniedForever,

  /// The platform could not determine the permission state.
  unableToDetermine,

  /// Foreground location is granted, but background location is still missing.
  backgroundPermissionRequired,

  /// Reserved for future networking-related location failures.
  networkError,
}

final class LocationReadyResult {
  const LocationReadyResult({
    required this.isSuccess,
    this.reason,
  });

  factory LocationReadyResult.success() {
    return const LocationReadyResult(isSuccess: true);
  }

  factory LocationReadyResult.failure({
    required LocationFailureReason reason,
  }) {
    return LocationReadyResult(
      isSuccess: false,
      reason: reason,
    );
  }

  final bool isSuccess;
  final LocationFailureReason? reason;
}
