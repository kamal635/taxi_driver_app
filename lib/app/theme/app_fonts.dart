import 'dart:ui';

final class FontChoice {
  const FontChoice(this.primary, this.fallback);

  final String primary;
  final List<String> fallback;
}

final class AppFonts {
  static const english = 'Inter';
  static const arabic = 'Cairo';

  static FontChoice resolve(Locale locale) {
    // Only special-case scripts where you want a specific primary font.
    // Arabic locales → force Cairo as primary.
    switch (locale.languageCode) {
      case 'ar':
        return const FontChoice(arabic, <String>[english]);
      default:
        return const FontChoice(english, <String>[arabic]);
    }
  }
}
