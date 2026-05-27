/// Availability-specific runtime failures that are not returned by the backend.
///
/// These failures are produced while starting/stopping local Android runtime
/// pieces such as notification permissions and the foreground service.
final class AvailabilityRuntimeFailure implements Exception {
  const AvailabilityRuntimeFailure({
    required this.reason,
    this.details,
  });

  final AvailabilityRuntimeFailureReason reason;
  final String? details;

  @override
  String toString() {
    final details = this.details;
    if (details == null || details.isEmpty) {
      return 'AvailabilityRuntimeFailure($reason)';
    }

    return 'AvailabilityRuntimeFailure($reason): $details';
  }
}

enum AvailabilityRuntimeFailureReason {
  missingAuthSession,
  notificationPermissionDenied,
  backgroundServiceStartFailed,
  backgroundServiceStopped,
  nativeRuntimeFailure,
}
