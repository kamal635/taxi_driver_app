import 'package:intl/intl.dart';

/// Formats a backend price string for UI display.
///
/// Syrian pound values are displayed without decimal digits and with comma
/// thousands separators, for example:
/// 3333 -> 3,333
/// 25000 -> 25,000
String formatOrderPrice(String rawPrice) {
  final normalizedPrice = _normalizePrice(rawPrice);
  final value = num.tryParse(normalizedPrice);

  if (value == null) {
    return rawPrice;
  }

  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(value);
}

String _normalizePrice(String rawPrice) {
  final value = rawPrice.trim();

  // Handle already-grouped values like 3.333 or 3,333 as 3333.
  if (RegExp(r'^\d{1,3}([\.,]\d{3})+$').hasMatch(value)) {
    return value.replaceAll(RegExp(r'[\.,]'), '');
  }

  return value;
}
