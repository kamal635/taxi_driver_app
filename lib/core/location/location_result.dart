enum LocationFailureReason {
  /// GPS / Location services are OFF.
  serviceDisabled,

  /// Permission denied (can request again).
  permissionDenied,

  /// Permission denied forever (must enable from Settings).
  permissionDeniedForever,

  /// Permission state can't be determined (e.g., unsupported platform/browser).
  unableToDetermine,

  networkError,
}

final class LocationReadyResult {
  LocationReadyResult({
    required this.isSuccess,
    this.reason,
  });

  factory LocationReadyResult.success() {
    return LocationReadyResult(isSuccess: true);
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
