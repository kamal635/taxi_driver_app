import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';
import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/router/keys/app_router_keys.dart';
import 'package:bawabat_al_saeq/app/router/shell/pages/app_shell_page.dart';
import 'package:bawabat_al_saeq/app/router/transitions/app_route_transition_page.dart';
import 'package:bawabat_al_saeq/features/home/presentation/pages/home_page.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/pages/change_password/change_password_page.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/pages/profile/profile_page.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/pages/trips_page.dart';
import 'package:go_router/go_router.dart';

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
            ],
          ),
        ],
      ),
    ],
  );
}
