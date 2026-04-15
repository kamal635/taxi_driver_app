import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_names.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/router/keys/app_router_keys.dart';
import 'package:taxi_driver_app/app/router/transitions/app_route_transition_page.dart';
import 'package:taxi_driver_app/features/account_security/presentation/pages/setup_password_page.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';

List<RouteBase> buildAuthRoutes() {
  return <RouteBase>[
    GoRoute(
      path: AppRoutePaths.login,
      name: AppRouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      parentNavigatorKey: AppRouterKeys.rootNavigatorKey,
      path: AppRoutePaths.setupPassword,
      name: AppRouteNames.setupPassword,
      pageBuilder: (context, state) => buildFadeSlidePage(
        state: state,
        child: const SetupPasswordPage(),
      ),
    ),
  ];
}
