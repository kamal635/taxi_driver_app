final class JsonReader {
  const JsonReader._();

  /// Returns a non-empty trimmed string.
  static String requireString(Map<String, dynamic> json, String key) {
    final value = optionalString(json, key);
    if (value == null) {
      throw FormatException('Missing or empty "$key"');
    }

    return value;
  }

  /// Returns the first non-empty trimmed string found in [keys].
  static String requireAnyString(
    Map<String, dynamic> json,
    Iterable<String> keys,
  ) {
    final value = optionalAnyString(json, keys);
    if (value == null) {
      throw FormatException('Missing or empty one of: ${keys.join(', ')}');
    }

    return value;
  }

  /// Returns a trimmed string, or null when the value is missing or empty.
  static String? optionalString(Map<String, dynamic> json, String key) {
    final text = _readTrimmedValue(json, key);
    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  /// Returns the first non-empty trimmed string found in [keys], or null.
  static String? optionalAnyString(
    Map<String, dynamic> json,
    Iterable<String> keys,
  ) {
    for (final key in keys) {
      final value = optionalString(json, key);
      if (value != null) return value;
    }

    return null;
  }

  static int requireInt(Map<String, dynamic> json, String key) {
    final value = optionalInt(json, key);
    if (value == null) {
      throw FormatException('Missing or invalid int in "$key"');
    }

    return value;
  }

  static int? optionalInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString().trim());
  }

  static double requireDouble(Map<String, dynamic> json, String key) {
    final value = optionalDouble(json, key);
    if (value == null) {
      throw FormatException('Missing or invalid double in "$key"');
    }

    return value;
  }

  static double? optionalDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString().trim());
  }

  static bool requireBool(Map<String, dynamic> json, String key) {
    final value = optionalBool(json, key);
    if (value == null) {
      throw FormatException('Missing or invalid bool in "$key"');
    }

    return value;
  }

  static bool? optionalBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;

    final text = value.toString().trim().toLowerCase();
    return switch (text) {
      'true' || '1' || 'yes' => true,
      'false' || '0' || 'no' => false,
      _ => null,
    };
  }

  /// Returns a parsed [DateTime].
  static DateTime requireDateTime(Map<String, dynamic> json, String key) {
    final value = optionalDateTime(json, key);
    if (value == null) {
      throw FormatException('Missing or invalid DateTime in "$key"');
    }

    return value;
  }

  /// Returns the first valid [DateTime] found in [keys].
  static DateTime requireAnyDateTime(
    Map<String, dynamic> json,
    Iterable<String> keys,
  ) {
    final value = optionalAnyDateTime(json, keys);
    if (value == null) {
      throw FormatException(
        'Missing or invalid DateTime in one of: ${keys.join(', ')}',
      );
    }

    return value;
  }

  /// Returns a parsed [DateTime], or null when the value is missing or empty.
  static DateTime? optionalDateTime(Map<String, dynamic> json, String key) {
    final text = optionalString(json, key);
    if (text == null) return null;

    return DateTime.tryParse(text);
  }

  /// Returns the first valid [DateTime] found in [keys], or null.
  static DateTime? optionalAnyDateTime(
    Map<String, dynamic> json,
    Iterable<String> keys,
  ) {
    for (final key in keys) {
      final value = optionalDateTime(json, key);
      if (value != null) return value;
    }

    return null;
  }

  static Map<String, dynamic> requireMap(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = optionalMap(json, key);
    if (value == null) {
      throw FormatException('Missing or invalid map in "$key"');
    }

    return value;
  }

  static Map<String, dynamic>? optionalMap(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  static List<Map<String, dynamic>> optionalMapList(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is! List) return const [];

    return value
        .whereType<Map<String, dynamic>>()
        .map((item) => item.cast<String, dynamic>())
        .toList(growable: false);
  }

  static String? _readTrimmedValue(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value?.toString().trim();
  }
}
