import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/router/shell/widgets/app_shell_effects.dart';
import 'package:bawabat_al_saeq/app/router/shell/widgets/app_top_bar.dart';
import 'package:bawabat_al_saeq/app/router/shell/widgets/bottom_navigation_bar.dart';
import 'package:bawabat_al_saeq/app/router/shell/widgets/connection_status_banner.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/listeners/availability_feedback_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  String _pageTitle(BuildContext context) {
    final l10n = context.l10n;

    return switch (navigationShell.currentIndex) {
      0 => l10n.navHome,
      1 => l10n.navTrips,
      _ => l10n.navProfile,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        Scaffold(
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
                        title: _pageTitle(context),
                        onAvatarPressed: () =>
                            context.go(AppRoutePaths.profile),
                      ),
                      const ConnectionStatusBanner(),
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
        ),
        const AppShellEffects(),
        const AvailabilityFeedbackListener(),
      ],
    );
  }
}
