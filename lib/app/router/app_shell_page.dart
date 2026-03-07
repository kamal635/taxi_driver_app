import 'dart:async' show unawaited;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/bottom_nav.dart';
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
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final pageTitle = switch (navigationShell.currentIndex) {
      0 => l10n.navHome,
      1 => l10n.navTrips,
      _ => l10n.navProfile,
    };

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  AppSpacing.h8,
                  AppTopBar(
                    title: pageTitle,
                    avatarText: 'A',
                    onBellPressed: () {},
                    onAvatarPressed: () {
                      context.go('/profile');
                    },
                  ),
                  AppSpacing.h8,
                ],
              ),
            ),
            Expanded(child: navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        index: navigationShell.currentIndex,
        onChanged: navigationShell.goBranch,
        homeLabel: l10n.navHome,
        tripsLabel: l10n.navTrips,
        profileLabel: l10n.navProfile,
      ),
    );
  }
}

class AppTopBar extends ConsumerStatefulWidget {
  const AppTopBar({
    required this.title,
    required this.avatarText,
    required this.onBellPressed,
    required this.onAvatarPressed,
    super.key,
  });

  final String title;
  final String avatarText;
  final VoidCallback onBellPressed;
  final VoidCallback onAvatarPressed;

  @override
  ConsumerState<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends ConsumerState<AppTopBar> {
  ProviderSubscription<bool>? _onlineSub;
  ProviderSubscription<LocationFailureReason?>? _errorSub;
  ProviderSubscription<Object?>? _serverErrorSub;

  @override
  void initState() {
    super.initState();

    _onlineSub = ref.listenManual<bool>(
      availabilityProvider.select((s) => s.isOnline),
      (prev, next) {
        if (prev == next) return;

        if (next) {
          unawaited(ref.read(newOfferControllerProvider.notifier).start());
        } else {
          unawaited(ref.read(newOfferControllerProvider.notifier).stop());
        }
      },
    );
    _serverErrorSub = ref.listenManual<Object?>(
      availabilityProvider.select((s) => s.serverError),
      (previous, next) {
        if (next == null || identical(previous, next)) return;

        final msg = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(msg, type: AppSnackType.error);

        ref.read(availabilityProvider.notifier).clearServerError();
      },
    );
    _errorSub = ref.listenManual<LocationFailureReason?>(
      availabilityProvider.select((s) => s.errorReason),
      (previous, next) {
        if (next == null || next == previous) return;

        final l10n = context.l10n;

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

        final locationService = ref.read(locationServiceProvider);

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

        ref.read(availabilityProvider.notifier).clearError();
      },
    );
  }

  @override
  void dispose() {
    _onlineSub?.close();
    _errorSub?.close();
    _serverErrorSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Read both values in one watch (rebuild only when either changes).
    final (:isOnline, :isBusy) = ref.watch(
      availabilityProvider.select(
        (s) => (isOnline: s.isOnline, isBusy: s.isBusy),
      ),
    );

    final avatarAsync = ref.watch(avatarControllerProvider);
    final avatarPath = avatarAsync.value;

    final session = ref.watch(authSessionProvider);
    final name = session.driverName?.trim() ?? '';
    final initial = name.isNotEmpty ? name[0] : '—';

    final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: widget.onBellPressed,
              icon: const Icon(Icons.notifications_none_rounded),
              color: AppColors.textPrimary,
            ),
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTypography.titleSm,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PillSwitch(
                  value: isOnline,
                  onChanged: isBusy
                      ? null
                      : (v) {
                          unawaited(
                            ref
                                .read(availabilityProvider.notifier)
                                .requestSetOnline(value: v),
                          );
                        },
                  offLabel: l10n.offline,
                  onLabel: l10n.online,
                  uppercase: false,
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
                                return Text(
                                  initial,
                                  style: AppTypography.labelMd,
                                );
                              },
                            ),
                          )
                        : Text(
                            initial,
                            style: AppTypography.labelMd,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
