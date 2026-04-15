abstract final class AppRoutePaths {
  const AppRoutePaths._();

  static const String login = '/login';
  static const String setupPassword = '/setupPassword';

  static const String home = '/home';
  static const String trips = '/trips';
  static const String profile = '/profile';
  static const String profilePassword = '/profile/password';
  static const String profileAppUpdate = '/profile/app-update';

  static const String profilePasswordSegment = 'password';
  static const String profileAppUpdateSegment = 'app-update';

  static const Set<String> authFlowPaths = {
    login,
    setupPassword,
  };
}
