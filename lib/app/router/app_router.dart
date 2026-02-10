import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/features/home/presentation/pages/home_placeholder_page.dart';

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePlaceholderPage(),
      ),
    ],
  );
}
