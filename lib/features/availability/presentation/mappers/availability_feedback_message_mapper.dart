import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/domain/failures/availability_runtime_failure.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';

/// Converts availability failures into localized UI messages/actions.
final class AvailabilityFeedbackMessageMapper {
  const AvailabilityFeedbackMessageMapper._();

  static String availabilityErrorToUserMessage(
    Object error, {
    required AppLocalizations l10n,
  }) {
    if (error is AvailabilityRuntimeFailure) {
      return switch (error.reason) {
        AvailabilityRuntimeFailureReason.missingAuthSession =>
          l10n.errorSessionExpired,
        AvailabilityRuntimeFailureReason.notificationPermissionDenied =>
          l10n.availabilityNotificationPermissionRequired,
        AvailabilityRuntimeFailureReason.backgroundServiceStartFailed =>
          l10n.availabilityBackgroundServiceStartFailed,
        AvailabilityRuntimeFailureReason.backgroundServiceStopped =>
          l10n.availabilityBackgroundServiceStopped,
        AvailabilityRuntimeFailureReason.nativeRuntimeFailure =>
          l10n.availabilityRuntimeError,
      };
    }

    return failureToUserMessage(error, l10n: l10n);
  }

  static String locationFailureToUserMessage(
    LocationFailureReason reason, {
    required AppLocalizations l10n,
  }) {
    return switch (reason) {
      LocationFailureReason.serviceDisabled => l10n.locationServiceDisabled,
      LocationFailureReason.permissionDenied => l10n.locationPermissionRequired,
      LocationFailureReason.permissionDeniedForever =>
        l10n.locationPermissionDeniedForever,
      LocationFailureReason.backgroundPermissionRequired =>
        l10n.locationBackgroundPermissionRequired,
      LocationFailureReason.unableToDetermine =>
        l10n.locationPermissionUnableToDetermine,
      LocationFailureReason.networkError => l10n.locationNetworkError,
    };
  }

  static String? locationFailureActionLabel(
    LocationFailureReason reason, {
    required AppLocalizations l10n,
  }) {
    return switch (reason) {
      LocationFailureReason.serviceDisabled ||
      LocationFailureReason.permissionDeniedForever ||
      LocationFailureReason.backgroundPermissionRequired => l10n.actionSettings,
      _ => null,
    };
  }
}
