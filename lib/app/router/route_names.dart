import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';

/// Backward-compatible route name aliases.
///
/// New code should import [AppRouteNames] directly. This class remains to avoid
/// breaking older feature files that still import `route_names.dart`.
abstract final class RouteNames {
  const RouteNames._();

  static const String login = AppRouteNames.login;
  static const String setupPassword = AppRouteNames.setupPassword;

  static const String home = AppRouteNames.home;
  static const String trips = AppRouteNames.trips;
  static const String profile = AppRouteNames.profile;
  static const String profilePassword = AppRouteNames.profilePassword;
  static const String profileLanguage = AppRouteNames.profileLanguage;
}
