import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/location/location_providers.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';

class AvailabilityFeedbackListener extends ConsumerStatefulWidget {
  const AvailabilityFeedbackListener({super.key});

  @override
  ConsumerState<AvailabilityFeedbackListener> createState() =>
      _AvailabilityFeedbackListenerState();
}

class _AvailabilityFeedbackListenerState
    extends ConsumerState<AvailabilityFeedbackListener> {
  ProviderSubscription<LocationFailureReason?>? _locationErrorSubscription;
  ProviderSubscription<Object?>? _serverErrorSubscription;

  @override
  void initState() {
    super.initState();

    _serverErrorSubscription = ref.listenManual<Object?>(
      availabilityProvider.select((state) => state.serverError),
      (previous, next) {
        if (next == null || identical(previous, next)) {
          return;
        }

        final message = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(message, type: AppSnackType.error);

        ref.read(availabilityProvider.notifier).clearServerError();
      },
    );

    _locationErrorSubscription = ref.listenManual<LocationFailureReason?>(
      availabilityProvider.select((state) => state.locationError),
      (previous, next) {
        if (next == null || next == previous) {
          return;
        }

        final l10n = context.l10n;
        final locationService = ref.read(locationServiceProvider);

        final message = switch (next) {
          LocationFailureReason.serviceDisabled => l10n.locationServiceDisabled,
          LocationFailureReason.permissionDenied =>
            l10n.locationPermissionRequired,
          LocationFailureReason.permissionDeniedForever =>
            l10n.locationPermissionDeniedForever,
          LocationFailureReason.unableToDetermine =>
            l10n.locationPermissionUnableToDetermine,
          LocationFailureReason.networkError => l10n.locationNetworkError,
        };

        final actionLabel = switch (next) {
          LocationFailureReason.serviceDisabled ||
          LocationFailureReason.permissionDeniedForever => l10n.actionSettings,
          _ => null,
        };

        final onAction = switch (next) {
          LocationFailureReason.serviceDisabled => () => unawaited(
            locationService.openLocationSettings(),
          ),
          LocationFailureReason.permissionDeniedForever => () => unawaited(
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
      },
    );
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
