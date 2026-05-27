import 'package:flutter/material.dart';

/// Centralized application color palette.
final class AppColors {
  AppColors._();

  // Brand colors.
  static const Color primary = Color(0xFFFFD400);
  static const Color brandNavy = Color(0xFF062F46);
  static const Color brandGold = primary;

  // Backgrounds.
  static const Color bgWarm = Color(0xFFFFF8E1);
  static const Color bgBase = Color(0xFFF7F7F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Text and borders.
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color iconMuted = Color(0xFF9CA3AF);

  // Semantic colors.
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFF2C1E0A);
  static const Color warningBg = Color(0xFFFFD166);
  static const Color info = Color(0xFF1D4ED8);
  static const Color infoBg = Color(0xFFEFF6FF);

  // Backward-compatible alias used by existing widgets.
  static const Color white = surface;
}
