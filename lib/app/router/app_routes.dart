import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';

abstract final class AppRoutes {
  const AppRoutes._();

  static const String login = AppRoutePaths.login;
  static const String setupPassword = AppRoutePaths.setupPassword;

  static const String home = AppRoutePaths.home;
  static const String trips = AppRoutePaths.trips;
  static const String profile = AppRoutePaths.profile;

  static const String profilePassword = AppRoutePaths.profilePassword;
}
