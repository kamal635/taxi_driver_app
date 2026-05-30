import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';

num parseTripAmount(String rawValue) {
  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) return 0;

  final sanitized = trimmed.replaceAll(RegExp('[^0-9,.-]'), '');
  if (sanitized.isEmpty) return 0;

  final normalized = _normalizeNumericValue(sanitized);
  return num.tryParse(normalized) ?? 0;
}

String formatTripAmount(num value) {
  if (value.isNaN || value.isInfinite) return '0';

  return formatOrderPrice(value.round().toString());
}

String _normalizeNumericValue(String value) {
  final hasComma = value.contains(',');
  final hasDot = value.contains('.');

  if (hasComma && hasDot) {
    final lastCommaIndex = value.lastIndexOf(',');
    final lastDotIndex = value.lastIndexOf('.');
    final decimalSeparator = lastCommaIndex > lastDotIndex ? ',' : '.';
    final thousandsSeparator = decimalSeparator == ',' ? '.' : ',';

    return value
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');
  }

  if (hasComma) {
    return _normalizeSingleSeparatorValue(value, ',');
  }

  if (hasDot) {
    return _normalizeSingleSeparatorValue(value, '.');
  }

  return value;
}

String _normalizeSingleSeparatorValue(String value, String separator) {
  final separatorCount = separator.allMatches(value).length;
  final parts = value.split(separator);

  if (separatorCount > 1) {
    return parts.join();
  }

  final fractionOrGroup = parts.last;
  final looksLikeThousandsGroup =
      fractionOrGroup.length == 3 && parts.first.isNotEmpty;

  if (looksLikeThousandsGroup) {
    return parts.join();
  }

  return value.replaceAll(separator, '.');
}
