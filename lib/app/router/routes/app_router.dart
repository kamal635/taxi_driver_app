import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/router/guards/app_route_guard.dart';
import 'package:taxi_driver_app/app/router/keys/app_router_keys.dart';
import 'package:taxi_driver_app/app/router/routes/auth_routes.dart';
import 'package:taxi_driver_app/app/router/routes/shell_routes.dart';
import 'package:taxi_driver_app/core/session/session_store.dart';

final class AppRouter {
  AppRouter._();

  static GoRouter create(AuthSession session) {
    return GoRouter(
      navigatorKey: AppRouterKeys.rootNavigatorKey,
      initialLocation: AppRoutePaths.login,
      debugLogDiagnostics: kDebugMode,
      refreshListenable: session,
      redirect: (context, state) {
        return AppRouteGuard.redirect(
          session: session,
          state: state,
        );
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(state.error?.toString() ?? 'Unknown routing error'),
        ),
      ),
      routes: <RouteBase>[
        ...buildAuthRoutes(),
        buildShellRoute(),
      ],
    );
  }
}
