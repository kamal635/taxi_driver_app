import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Semantic colors that change automatically with the active theme.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.backgroundDecorative,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.iconMuted,
    required this.shadow,
    required this.primary,
    required this.error,
    required this.errorBg,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.info,
    required this.infoBg,
  });

  final Color background;
  final Color backgroundDecorative;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color iconMuted;
  final Color shadow;
  final Color primary;
  final Color error;
  final Color errorBg;
  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color info;
  final Color infoBg;

  static const light = AppThemeColors(
    background: AppColors.bgBase,
    backgroundDecorative: AppColors.bgWarm,
    surface: AppColors.surface,
    surfaceMuted: Color(0xFFF9FAFB),
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    border: AppColors.border,
    iconMuted: AppColors.iconMuted,
    shadow: Color(0x0A000000),
    primary: AppColors.primary,
    error: AppColors.error,
    errorBg: AppColors.errorBg,
    success: AppColors.success,
    successBg: AppColors.successBg,
    warning: AppColors.warning,
    warningBg: AppColors.warningBg,
    info: AppColors.info,
    infoBg: AppColors.infoBg,
  );

  static const dark = AppThemeColors(
    background: Color(0xFF071018),
    backgroundDecorative: Color(0xFF0B1720),
    surface: Color(0xFF101B24),
    surfaceMuted: Color(0xFF162430),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFB6C2CF),
    border: Color(0xFF263744),
    iconMuted: Color(0xFF8EA0AE),
    shadow: Color(0x52000000),
    primary: AppColors.primary,
    error: Color(0xFFF87171),
    errorBg: Color(0xFF3A1518),
    success: Color(0xFF4ADE80),
    successBg: Color(0xFF11351F),
    warning: Color(0xFFFFD166),
    warningBg: Color(0xFF3A2A0E),
    info: Color(0xFF93C5FD),
    infoBg: Color(0xFF112B46),
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? backgroundDecorative,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? iconMuted,
    Color? shadow,
    Color? primary,
    Color? error,
    Color? errorBg,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? info,
    Color? infoBg,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      backgroundDecorative: backgroundDecorative ?? this.backgroundDecorative,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      iconMuted: iconMuted ?? this.iconMuted,
      shadow: shadow ?? this.shadow,
      primary: primary ?? this.primary,
      error: error ?? this.error,
      errorBg: errorBg ?? this.errorBg,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundDecorative: Color.lerp(
        backgroundDecorative,
        other.backgroundDecorative,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get colors {
    return Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
  }
}
