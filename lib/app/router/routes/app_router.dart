import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/router/guards/app_route_guard.dart';
import 'package:bawabat_al_saeq/app/router/keys/app_router_keys.dart';
import 'package:bawabat_al_saeq/app/router/routes/auth_routes.dart';
import 'package:bawabat_al_saeq/app/router/routes/shell_routes.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/pages/app_error_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

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
      errorBuilder: (context, state) => AppErrorPage(
        title: context.l10n.errorUnexpected,
        message: state.error?.toString(),
      ),
      routes: <RouteBase>[
        ...buildAuthRoutes(),
        buildShellRoute(),
      ],
    );
  }
}
