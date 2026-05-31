import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Appearance selection screen shown from the profile section.
class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(appSettingsProvider);

    return AppOverlayScaffold(
      title: l10n.profileAppearanceTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileAppearancePageSubtitle,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.h16,
          AppCardSurface(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 4.h,
            ),
            child: Column(
              children: [
                ProfileSectionItem(
                  title: l10n.profileAppearanceSystemTitle,
                  subtitle: l10n.profileAppearanceSystemSubtitle,
                  icon: Icons.brightness_auto_rounded,
                  onPressed: () => _selectThemeMode(
                    ref,
                    ThemeMode.system,
                  ),
                  trailing: _AppearanceSelectionIndicator(
                    isSelected: settings.themeMode == ThemeMode.system,
                  ),
                ),
                ProfileSectionItem(
                  title: l10n.profileAppearanceLightTitle,
                  subtitle: l10n.profileAppearanceLightSubtitle,
                  icon: Icons.light_mode_rounded,
                  onPressed: () => _selectThemeMode(
                    ref,
                    ThemeMode.light,
                  ),
                  trailing: _AppearanceSelectionIndicator(
                    isSelected: settings.themeMode == ThemeMode.light,
                  ),
                ),
                ProfileSectionItem(
                  title: l10n.profileAppearanceDarkTitle,
                  subtitle: l10n.profileAppearanceDarkSubtitle,
                  icon: Icons.dark_mode_rounded,
                  onPressed: () => _selectThemeMode(
                    ref,
                    ThemeMode.dark,
                  ),
                  trailing: _AppearanceSelectionIndicator(
                    isSelected: settings.themeMode == ThemeMode.dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectThemeMode(WidgetRef ref, ThemeMode themeMode) {
    unawaited(
      ref.read(appSettingsControllerProvider).setThemeMode(themeMode),
    );
  }
}

class _AppearanceSelectionIndicator extends StatelessWidget {
  const _AppearanceSelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Icon(
        isSelected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
        key: ValueKey<bool>(isSelected),
        size: 22.r,
        color: isSelected ? context.colors.primary : context.colors.iconMuted,
      ),
    );
  }
}
