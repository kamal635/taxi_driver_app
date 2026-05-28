import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/location/location_providers.dart';
import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/domain/failures/availability_runtime_failure.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/availability_controller.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows one-shot availability errors produced by [AvailabilityController].
final class AvailabilityFeedbackListener extends ConsumerStatefulWidget {
  const AvailabilityFeedbackListener({super.key});

  @override
  ConsumerState<AvailabilityFeedbackListener> createState() =>
      _AvailabilityFeedbackListenerState();
}

final class _AvailabilityFeedbackListenerState
    extends ConsumerState<AvailabilityFeedbackListener> {
  ProviderSubscription<LocationFailureReason?>? _locationErrorSubscription;
  ProviderSubscription<Object?>? _serverErrorSubscription;

  @override
  void initState() {
    super.initState();

    _serverErrorSubscription = ref.listenManual<Object?>(
      availabilityProvider.select((state) => state.serverError),
      _handleServerErrorChanged,
    );

    _locationErrorSubscription = ref.listenManual<LocationFailureReason?>(
      availabilityProvider.select((state) => state.locationError),
      _handleLocationErrorChanged,
    );
  }

  void _handleServerErrorChanged(Object? previous, Object? next) {
    if (next == null || identical(previous, next)) {
      return;
    }

    final message = _availabilityErrorToUserMessage(
      next,
      l10n: context.l10n,
    );

    context.showAppSnack(message, type: AppSnackType.error);
    ref.read(availabilityProvider.notifier).clearServerError();
  }

  void _handleLocationErrorChanged(
    LocationFailureReason? previous,
    LocationFailureReason? next,
  ) {
    if (next == null || next == previous) {
      return;
    }

    final l10n = context.l10n;
    final locationService = ref.read(locationServiceProvider);

    final message = _locationFailureToUserMessage(next, l10n: l10n);
    final actionLabel = _locationFailureActionLabel(next, l10n: l10n);
    final onAction = switch (next) {
      LocationFailureReason.serviceDisabled => () => unawaited(
        locationService.openLocationSettings(),
      ),
      LocationFailureReason.permissionDeniedForever ||
      LocationFailureReason.backgroundPermissionRequired => () => unawaited(
        locationService.openAppSettings(),
      ),
      _ => null,
    };

    context.showAppSnack(
      message,
      type: AppSnackType.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );

    ref.read(availabilityProvider.notifier).clearLocationError();
  }

  String _availabilityErrorToUserMessage(
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

  String _locationFailureToUserMessage(
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

  String? _locationFailureActionLabel(
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

  @override
  void dispose() {
    _locationErrorSubscription?.close();
    _serverErrorSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
