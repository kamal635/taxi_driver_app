import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/router/app_shell_page.dart';
import 'package:taxi_driver_app/app/router/route_names.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/pages/profile_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/change_password_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/vehicle_info_page.dart';
import 'package:taxi_driver_app/features/trips/presentation/pages/trips_page.dart';

final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> _homeBranchKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
  static final GlobalKey<NavigatorState> _tripsBranchKey =
      GlobalKey<NavigatorState>(debugLabel: 'tripsBranch');
  static final GlobalKey<NavigatorState> _profileBranchKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileBranch');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeBranchKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _tripsBranchKey,
            routes: [
              GoRoute(
                path: AppRoutes.trips,
                name: RouteNames.trips,
                builder: (context, state) => const TripsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileBranchKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: AppRoutes.profilePassword,
                    name: RouteNames.profilePassword,
                    pageBuilder: (context, state) => _fadeSlidePage(
                      state: state,
                      child: const ChangePasswordPage(),
                    ),
                  ),

                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: AppRoutes.profileVehicles,
                    name: RouteNames.profileVehicles,
                    pageBuilder: (context, state) => _fadeSlidePage(
                      state: state,
                      child: const VehicleInfoPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage<void> _fadeSlidePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
