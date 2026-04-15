import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_names.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/router/keys/app_router_keys.dart';
import 'package:taxi_driver_app/app/router/shell/pages/app_shell_page.dart';
import 'package:taxi_driver_app/app/router/transitions/app_route_transition_page.dart';
import 'package:taxi_driver_app/features/app_update/presentation/pages/app_update_page.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/pages/change_password_page.dart';
import 'package:taxi_driver_app/features/profile/presentation/pages/profile_page.dart';
import 'package:taxi_driver_app/features/trips/presentation/pages/trips_page.dart';

RouteBase buildShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppShellPage(navigationShell: navigationShell);
    },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        navigatorKey: AppRouterKeys.homeBranchNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.home,
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: AppRouterKeys.tripsBranchNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.trips,
            name: AppRouteNames.trips,
            builder: (context, state) => const TripsPage(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: AppRouterKeys.profileBranchNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.profile,
            name: AppRouteNames.profile,
            builder: (context, state) => const ProfilePage(),
            routes: <RouteBase>[
              GoRoute(
                parentNavigatorKey: AppRouterKeys.rootNavigatorKey,
                path: AppRoutePaths.profilePasswordSegment,
                name: AppRouteNames.profilePassword,
                pageBuilder: (context, state) => buildFadeSlidePage(
                  state: state,
                  child: const ChangePasswordPage(),
                ),
              ),
              GoRoute(
                parentNavigatorKey: AppRouterKeys.rootNavigatorKey,
                path: AppRoutePaths.profileAppUpdateSegment,
                name: AppRouteNames.profileAppUpdate,
                pageBuilder: (context, state) => buildFadeSlidePage(
                  state: state,
                  child: const AppUpdatePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
