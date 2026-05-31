import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/common/profile_selection_indicator.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppearanceOptionList extends ConsumerWidget {
  const AppearanceOptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedThemeMode = ref.watch(
      appSettingsProvider.select((settings) => settings.themeMode),
    );

    return AppCardSurface(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        children: [
          ProfileSectionItem(
            title: l10n.profileAppearanceSystemTitle,
            subtitle: l10n.profileAppearanceSystemSubtitle,
            icon: Icons.brightness_auto_rounded,
            onPressed: () => _selectThemeMode(ref, ThemeMode.system),
            trailing: ProfileSelectionIndicator(
              isSelected: selectedThemeMode == ThemeMode.system,
            ),
          ),
          ProfileSectionItem(
            title: l10n.profileAppearanceLightTitle,
            subtitle: l10n.profileAppearanceLightSubtitle,
            icon: Icons.light_mode_rounded,
            onPressed: () => _selectThemeMode(ref, ThemeMode.light),
            trailing: ProfileSelectionIndicator(
              isSelected: selectedThemeMode == ThemeMode.light,
            ),
          ),
          ProfileSectionItem(
            title: l10n.profileAppearanceDarkTitle,
            subtitle: l10n.profileAppearanceDarkSubtitle,
            icon: Icons.dark_mode_rounded,
            onPressed: () => _selectThemeMode(ref, ThemeMode.dark),
            trailing: ProfileSelectionIndicator(
              isSelected: selectedThemeMode == ThemeMode.dark,
            ),
          ),
        ],
      ),
    );
  }

  void _selectThemeMode(WidgetRef ref, ThemeMode themeMode) {
    unawaited(ref.read(appSettingsControllerProvider).setThemeMode(themeMode));
  }
}
