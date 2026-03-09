final class JsonReader {
  const JsonReader._();

  /// Returns a non-empty string.
  /// Throws [FormatException] if the key is missing or empty.
  static String requireString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing "$key"');
    }

    final text = value.toString().trim();
    if (text.isEmpty) {
      throw FormatException('Empty "$key"');
    }

    return text;
  }

  /// Returns a trimmed string, or null if missing/empty.
  static String? optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  /// Returns a parsed DateTime.
  /// Throws [FormatException] if the key is missing or invalid.
  static DateTime requireDateTime(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing "$key"');
    }

    try {
      return DateTime.parse(value.toString());
    } on Exception catch (_) {
      throw FormatException('Invalid DateTime in "$key": $value');
    }
  }

  /// Returns a parsed DateTime, or null if missing/empty.
  /// Throws [FormatException] only if the value exists but is invalid.
  static DateTime? optionalDateTime(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    try {
      return DateTime.parse(text);
    } on Exception catch (_) {
      throw FormatException('Invalid DateTime in "$key": $value');
    }
  }
}
