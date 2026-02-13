// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Taxi Driver App';

  @override
  String get brandName => 'Syrian Taxi';

  @override
  String get brandSubtitle => 'Approved drivers platform';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get phoneHint => '09xx xxx xxx';

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
