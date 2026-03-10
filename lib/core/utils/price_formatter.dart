import 'package:intl/intl.dart';

String formatOrderPrice(String rawPrice) {
  final value = num.tryParse(rawPrice);
  if (value == null) return rawPrice;

  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(value).replaceAll(',', '.');
}
