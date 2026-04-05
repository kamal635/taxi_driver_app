import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/router/app_shell_page.dart';
import 'package:taxi_driver_app/app/router/route_names.dart';
import 'package:taxi_driver_app/core/session/auth_session.dart';
import 'package:taxi_driver_app/features/auth/presentation/account_security/presentation/pages/setup_password_page.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/pages/change_password_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/pages/profile_page.dart';
import 'package:taxi_driver_app/features/trips/presentation/pages/trips_page.dart';

final class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> _homeBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
  static final GlobalKey<NavigatorState> _tripsBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'tripsBranch');
  static final GlobalKey<NavigatorState> _profileBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileBranch');

  static GoRouter create(AuthSession session) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: kDebugMode,
      refreshListenable: session,
      redirect: (context, state) => _redirect(session: session, state: state),
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(state.error?.toString() ?? 'Unknown routing error'),
        ),
      ),
      routes: <RouteBase>[
        _loginRoute(),
        _setupPasswordRoute(),
        _shellRoute(),
      ],
    );
  }

  static String? _redirect({
    required AuthSession session,
    required GoRouterState state,
  }) {
    if (!session.isReady) return null;

    final location = state.matchedLocation;
    final isInAuthFlow =
        location == AppRoutes.login || location == AppRoutes.setupPassword;

    final isLoggedIn = session.isLoggedIn;
    final mustChangePassword = session.mustChangePassword;

    if (!isLoggedIn) {
      return isInAuthFlow ? null : AppRoutes.login;
    }

    if (mustChangePassword) {
      return location == AppRoutes.setupPassword
          ? null
          : AppRoutes.setupPassword;
    }

    if (isInAuthFlow) {
      return AppRoutes.home;
    }

    return null;
  }

  static GoRoute _loginRoute() {
    return GoRoute(
      path: AppRoutes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    );
  }

  static GoRoute _setupPasswordRoute() {
    return GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.setupPassword,
      name: RouteNames.setupPassword,
      pageBuilder: (context, state) => _buildFadeSlidePage(
        state: state,
        child: const SetupPasswordPage(),
      ),
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
      navigatorKey: _homeBranchNavigatorKey,
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
      navigatorKey: _tripsBranchNavigatorKey,
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
      navigatorKey: _profileBranchNavigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.profile,
          name: RouteNames.profile,
          builder: (context, state) => const ProfilePage(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: AppRoutes.profilePassword,
              name: RouteNames.profilePassword,
              pageBuilder: (context, state) => _buildFadeSlidePage(
                state: state,
                child: const ChangePasswordPage(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static CustomTransitionPage<void> _buildFadeSlidePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
