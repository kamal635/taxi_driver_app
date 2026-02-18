import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/bottom_nav.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_background.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/core/widgets/availability_card.dart';

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
      body: Stack(
        children: [
          const AppBackground(),

          SafeArea(
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
                      AppSpacing.h12,
                    ],
                  ),
                ),

                /// The main content area where
                ///  the current page will be displayed
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
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

class AppTopBar extends StatefulWidget {
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
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  bool _isOnline = true;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final availability = _isOnline
        ? (
            title: l10n.homeAvailabilityOnTitle,
            subtitle: l10n.homeAvailabilityOnSubtitle,
          )
        : (
            title: l10n.homeAvailabilityOffTitle,
            subtitle: l10n.homeAvailabilityOffSubtitle,
          );
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

            GestureDetector(
              onTap: widget.onAvatarPressed,
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.taxiYellow, width: 2),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.avatarText,
                  style: AppTypography.labelMd,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.h12,

        /// Availability
        AvailabilityCard(
          isOnline: _isOnline,
          title: availability.title,
          subtitle: availability.subtitle,
          textPill: _isOnline ? l10n.online : l10n.offline,

          onChanged: (v) async {
            // Confirm only when turning OFF
            if (_isOnline && !v) {
              final ok = await showAppConfirmDialog(
                context: context,
                title: l10n.availabilityTurnOffTitle,
                message: l10n.availabilityTurnOffMessage,
                confirmLabel: l10n.actionConfirm,
                cancelLabel: l10n.actionCancel,
                icon: Icons.power_settings_new_rounded,
                barrierDismissible: true,
                backgroundIconColor: AppColors.errorBg,
                iconColor: AppColors.error,
              );

              if (!ok) return; // don't change anything
            }

            setState(() => _isOnline = v);
          },
        ),
      ],
    );
  }
}
