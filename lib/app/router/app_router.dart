import 'package:flutter/foundation.dart';
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
  AppRouter._(); // prevent instantiation

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
    debugLogDiagnostics: kDebugMode,

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(state.error?.toString() ?? 'Unknown routing error'),
      ),
    ),

    routes: _routes,
  );

  static final List<RouteBase> _routes = <RouteBase>[
    _loginRoute(),
    _shellRoute(),
  ];

  static GoRoute _loginRoute() {
    return GoRoute(
      path: AppRoutes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    );
  }

  static StatefulShellRoute _shellRoute() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShellPage(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        _homeBranch(),
        _tripsBranch(),
        _profileBranch(),
      ],
    );
  }

  static StatefulShellBranch _homeBranch() {
    return StatefulShellBranch(
      navigatorKey: _homeBranchKey,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.home,
          name: RouteNames.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }

  static StatefulShellBranch _tripsBranch() {
    return StatefulShellBranch(
      navigatorKey: _tripsBranchKey,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.trips,
          name: RouteNames.trips,
          builder: (context, state) => const TripsPage(),
        ),
      ],
    );
  }

  static StatefulShellBranch _profileBranch() {
    return StatefulShellBranch(
      navigatorKey: _profileBranchKey,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.profile,
          name: RouteNames.profile,
          builder: (context, state) => const ProfilePage(),
          routes: <RouteBase>[
            ..._profileOverlayRoutes(),
          ],
        ),
      ],
    );
  }

  static List<RouteBase> _profileOverlayRoutes() {
    return <RouteBase>[
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
    ];
  }

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
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
