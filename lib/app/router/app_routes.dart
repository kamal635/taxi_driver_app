import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';

/// Backward-compatible route path aliases.
///
/// New code should import [AppRoutePaths] directly. This class remains to avoid
/// breaking older feature files that still import `app_routes.dart`.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String login = AppRoutePaths.login;
  static const String setupPassword = AppRoutePaths.setupPassword;

  static const String home = AppRoutePaths.home;
  static const String trips = AppRoutePaths.trips;
  static const String profile = AppRoutePaths.profile;
  static const String profilePassword = AppRoutePaths.profilePassword;
}
