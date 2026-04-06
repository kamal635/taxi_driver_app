import 'dart:async' show unawaited;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/avatar/avatar_controller.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/location/location_providers.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/pill_switch.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';

class AppTopBar extends ConsumerStatefulWidget {
  const AppTopBar({
    required this.title,
    required this.onAvatarPressed,
    super.key,
  });

  final String title;
  final VoidCallback onAvatarPressed;

  @override
  ConsumerState<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends ConsumerState<AppTopBar> {
  ProviderSubscription<LocationFailureReason?>? _locationErrorSubscription;
  ProviderSubscription<Object?>? _serverErrorSubscription;

  @override
  void initState() {
    super.initState();
    _listenForAvailabilityErrors();
  }

  void _listenForAvailabilityErrors() {
    _serverErrorSubscription = ref.listenManual<Object?>(
      availabilityProvider.select((state) => state.serverError),
      (previous, next) {
        if (next == null || identical(previous, next)) return;

        final message = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(message, type: AppSnackType.error);

        ref.read(availabilityProvider.notifier).clearServerError();
      },
    );

    _locationErrorSubscription = ref.listenManual<LocationFailureReason?>(
      availabilityProvider.select((state) => state.locationError),
      (previous, next) {
        if (next == null || next == previous) return;

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

  Future<void> _handleAvailabilityChanged(bool value) async {
    final restoredCurrentOffer = ref.read(restoredCurrentOfferProvider);
    final acceptedOffer = ref
        .read(acceptOfferControllerProvider)
        .value
        ?.acceptedOffer;

    final hasActiveTrip = restoredCurrentOffer != null || acceptedOffer != null;

    if (value && hasActiveTrip) {
      context.showAppSnack(
        context.l10n.availabilityActiveTripOnlineBlocked,
        type: AppSnackType.error,
      );
      return;
    }

    await ref
        .read(availabilityProvider.notifier)
        .requestSetOnline(value: value);

    if (!mounted || value) return;

    ref
            .read(hasRequestedRestoreForCurrentOnlineSessionProvider.notifier)
            .state =
        false;
  }

  @override
  void dispose() {
    _locationErrorSubscription?.close();
    _serverErrorSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final (:isOnline, :isBusy) = ref.watch(
      availabilityProvider.select(
        (state) => (isOnline: state.isOnline, isBusy: state.isBusy),
      ),
    );

    final avatarAsync = ref.watch(avatarControllerProvider);
    final avatarPath = avatarAsync.value;

    final session = ref.watch(authSessionProvider);
    final name = session.driverName?.trim() ?? '';
    final initial = name.isNotEmpty ? name[0] : '—';

    final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;

    return Row(
      children: [
        AppSpacing.w10,
        PillSwitch(
          value: isOnline,
          onChanged: isBusy
              ? null
              : (value) => unawaited(_handleAvailabilityChanged(value)),
          offLabel: l10n.offline,
          onLabel: l10n.online,
          uppercase: false,
        ),
        Expanded(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: AppTypography.titleSm,
          ),
        ),
        AppSpacing.w12,
        GestureDetector(
          onTap: avatarAsync.isLoading ? null : widget.onAvatarPressed,
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              color: AppColors.white,
            ),
            alignment: Alignment.center,
            child: hasAvatar
                ? ClipOval(
                    child: Image.file(
                      File(avatarPath),
                      width: 38.r,
                      height: 38.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Text(initial, style: AppTypography.labelMd);
                      },
                    ),
                  )
                : Text(initial, style: AppTypography.labelMd),
          ),
        ),
      ],
    );
  }
}
