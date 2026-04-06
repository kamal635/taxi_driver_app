final class JsonReader {
  const JsonReader._();

  /// Returns a non-empty trimmed string.
  static String requireString(Map<String, dynamic> json, String key) {
    final text = _readTrimmedValue(json, key);

    if (text == null) {
      throw FormatException('Missing "$key"');
    }

    if (text.isEmpty) {
      throw FormatException('Empty "$key"');
    }

    return text;
  }

  /// Returns a trimmed string, or null when the value is missing or empty.
  static String? optionalString(Map<String, dynamic> json, String key) {
    final text = _readTrimmedValue(json, key);

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  /// Returns a parsed [DateTime].
  static DateTime requireDateTime(Map<String, dynamic> json, String key) {
    final text = _readTrimmedValue(json, key);

    if (text == null || text.isEmpty) {
      throw FormatException('Missing "$key"');
    }

    return _parseDateTime(text, key);
  }

  /// Returns a parsed [DateTime], or null when the value is missing or empty.
  static DateTime? optionalDateTime(Map<String, dynamic> json, String key) {
    final text = _readTrimmedValue(json, key);

    if (text == null || text.isEmpty) {
      return null;
    }

    return _parseDateTime(text, key);
  }

  static String? _readTrimmedValue(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value?.toString().trim();
  }

  static DateTime _parseDateTime(String rawValue, String key) {
    try {
      return DateTime.parse(rawValue);
    } on Exception catch (_) {
      throw FormatException('Invalid DateTime in "$key": $rawValue');
    }
  }
}
