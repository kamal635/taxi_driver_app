import 'package:bawabat_al_saeq/core/location/location_result.dart';

/// UI state for the driver availability flow.
final class AvailabilityState {
  const AvailabilityState({
    required this.isBusy,
    required this.isOnline,
    this.locationError,
    this.serverError,
  });

  final bool isOnline;
  final bool isBusy;

  /// Stores location-related errors that should be shown in the UI.
  final LocationFailureReason? locationError;

  /// Stores API/runtime errors that should be shown in the UI.
  final Object? serverError;

  static const Object _unset = Object();

  AvailabilityState copyWith({
    bool? isOnline,
    bool? isBusy,
    Object? locationError = _unset,
    Object? serverError = _unset,
  }) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      locationError: identical(locationError, _unset)
          ? this.locationError
          : locationError as LocationFailureReason?,
      serverError: identical(serverError, _unset)
          ? this.serverError
          : serverError,
    );
  }
}
