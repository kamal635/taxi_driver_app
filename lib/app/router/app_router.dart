import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/core/widgets/app_placeholder_page.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const AppPlaceholderPage(title: 'Home'),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const AppPlaceholderPage(title: 'Profile'),
      ),
    ],
  );
}
