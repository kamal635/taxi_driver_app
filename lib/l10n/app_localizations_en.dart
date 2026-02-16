// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taxi Driver App';

  @override
  String get brandName => 'Syrian Taxi';

  @override
  String get brandSubtitle => 'Approved drivers platform';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'example@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get signIn => 'Sign in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get copyright => '© 2026 Taxi Driver App';
}
