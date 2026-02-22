import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/bottom_nav.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/pill_switch.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_page.dart';

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

            /// The main content area where
            ///  the current page will be displayed
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

class AppTopBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBellPressed,
              icon: const Icon(Icons.notifications_none_rounded),
              color: AppColors.textPrimary,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.titleSm,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PillSwitch(
                  value: ref.watch(isOnlineProvider),
                  onChanged: (v) =>
                      ref.read(isOnlineProvider.notifier).state = v,
                  offLabel: l10n.offline,
                  onLabel: l10n.online,
                  uppercase: false,
                ),

                AppSpacing.w12,
                GestureDetector(
                  onTap: onAvatarPressed,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.taxiYellow, width: 2),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Text(avatarText, style: AppTypography.labelMd),
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
