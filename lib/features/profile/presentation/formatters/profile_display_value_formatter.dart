abstract final class ProfileDisplayValueFormatter {
  static String fallbackDash(String? value) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : '—';
  }

  static String firstInitial(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty ? trimmed.substring(0, 1) : '—';
  }
}
