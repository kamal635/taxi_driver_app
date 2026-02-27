import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_providers.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';

final availabilityProvider =
    NotifierProvider<AvailabilityController, AvailabilityState>(
      AvailabilityController.new,
    );

class AvailabilityController extends Notifier<AvailabilityState> {
  @override
  AvailabilityState build() {
    return AvailabilityState(
      isOnline: false,
      isBusy: false,
    );
  }

  void setBusy({required bool value}) {
    state = state.copyWith(isBusy: value);
  }

  Future<void> requestSetOnline({required bool value}) async {
    // Guard: prevent double taps / concurrent calls
    if (state.isBusy) return;

    setBusy(value: true);

    // Clear previous errors at the start of a new attempt
    state = state.copyWith(
      errorMessage: null,
      errorReason: null,
    );

    try {
      if (value) {
        final locationService = ref.read(locationServiceProvider);
        final ready = await locationService.ensureReady();

        if (!ready.isSuccess) {
          // Don't go online if location isn't ready
          state = state.copyWith(
            isOnline: false,
            errorReason:
                ready.reason ?? LocationFailureReason.unableToDetermine,
          );
          return;
        }
      }

      // Success (or turning offline)
      state = state.copyWith(isOnline: value);
    } on Exception catch (_) {
      // Fallback for unexpected exceptions
      state = state.copyWith(
        isOnline: false,
        errorReason: LocationFailureReason.unableToDetermine,
      );
    } finally {
      setBusy(value: false);
    }
  }

  bool get online => state.isOnline;

  void clearError() {
    state = state.copyWith(errorMessage: null, errorReason: null);
  }
}

final class AvailabilityState {
  AvailabilityState({
    required this.isBusy,
    required this.isOnline,
    this.errorMessage,
    this.errorReason,
  });

  final bool isOnline;
  final bool isBusy;

  /// Generic non-localized error (optional)
  final String? errorMessage;

  /// Reason-based error (best for localization in UI)
  final LocationFailureReason? errorReason;

  static const Object _unset = Object();

  AvailabilityState copyWith({
    bool? isOnline,
    bool? isBusy,
    Object? errorMessage = _unset,
    Object? errorReason = _unset,
  }) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      errorReason: identical(errorReason, _unset)
          ? this.errorReason
          : errorReason as LocationFailureReason?,
    );
  }
}
