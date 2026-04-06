import 'dart:ui';

/// Selected font family with ordered fallbacks.
final class FontChoice {
  const FontChoice(this.primary, this.fallback);

  final String primary;
  final List<String> fallback;
}

/// Centralized application font families.
final class AppFonts {
  AppFonts._();

  static const String english = 'Archivo';
  static const String arabic = 'NotoKufiArabic';

  /// Resolve the primary font for the active locale.
  static FontChoice resolve(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return const FontChoice(arabic, <String>[english]);
      default:
        return const FontChoice(english, <String>[arabic]);
    }
  }
}
