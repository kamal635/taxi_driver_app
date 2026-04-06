import 'package:intl/intl.dart';

/// Formats a backend price string for UI display.
///
/// The current UI convention uses dot separators, for example:
/// 12000 -> 12.000
String formatOrderPrice(String rawPrice) {
  final value = num.tryParse(rawPrice);
  if (value == null) {
    return rawPrice;
  }

  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(value).replaceAll(',', '.');
}
