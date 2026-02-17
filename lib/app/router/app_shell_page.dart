import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/bottom_nav.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_background.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AppBackground(),
          navigationShell,
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
