import 'package:flutter/services.dart' show MethodChannel;

/// Small helper for safely reading native [MethodChannel] argument maps.
final class DriverBackgroundServiceArgumentsReader {
  const DriverBackgroundServiceArgumentsReader._();

  static Map<Object?, Object?> asMap(Object? arguments) {
    if (arguments is Map<Object?, Object?>) {
      return arguments;
    }

    if (arguments is Map) {
      return Map<Object?, Object?>.from(arguments);
    }

    return const <Object?, Object?>{};
  }

  static String string(
    Map<Object?, Object?> map,
    String key, {
    required String fallback,
  }) {
    final value = nullableString(map, key);
    if (value == null || value.isEmpty) {
      return fallback;
    }

    return value;
  }

  static String? nullableString(Map<Object?, Object?> map, String key) {
    final value = map[key];
    if (value == null) return null;

    final text = value.toString();
    if (text.isEmpty || text == 'null') return null;

    return text;
  }
}
