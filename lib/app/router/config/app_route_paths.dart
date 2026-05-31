abstract final class AppRoutePaths {
  const AppRoutePaths._();

  static const String login = '/login';
  static const String setupPassword = '/setupPassword';

  static const String home = '/home';
  static const String trips = '/trips';
  static const String profile = '/profile';
  static const String profilePassword = '/profile/password';
  static const String profileLanguage = '/profile/language';
  static const String profileAppearance = '/profile/appearance';
  static const String profileLocationStatus = '/profile/location-status';
  static const String profileAbout = '/profile/about';

  static const String profilePasswordSegment = 'password';
  static const String profileLanguageSegment = 'language';
  static const String profileAppearanceSegment = 'appearance';
  static const String profileLocationStatusSegment = 'location-status';
  static const String profileAboutSegment = 'about';

  static const Set<String> authFlowPaths = {
    login,
    setupPassword,
  };
}
