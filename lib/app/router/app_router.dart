import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_shell_page.dart';
import 'package:taxi_driver_app/core/widgets/app_placeholder_page.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_page.dart';
import 'package:taxi_driver_app/features/trips/presentation/pages/trips_page.dart';

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trips',
                name: 'trips',
                builder: (context, state) => const TripsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) =>
                    const AppPlaceholderPage(title: 'Profile'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
