import 'package:bawabat_al_saeq/app/settings/app_settings_state.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/common/profile_code_badge.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:flutter/material.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({
    required this.settings,
    required this.onChangePasswordPressed,
    required this.onAppearancePressed,
    required this.onLanguagePressed,
    required this.onLocationStatusPressed,
    super.key,
  });

  final AppSettingsState settings;
  final VoidCallback onChangePasswordPressed;
  final VoidCallback onAppearancePressed;
  final VoidCallback onLanguagePressed;
  final VoidCallback onLocationStatusPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabicLocale = settings.isArabic;

    return ProfileSection(
      title: l10n.profileSectionAccount,
      children: [
        ProfileSectionItem(
          title: l10n.profileChangePasswordTitle,
          subtitle: l10n.profileChangePasswordSubtitle,
          icon: AppIcons.lock,
          onPressed: onChangePasswordPressed,
        ),
        ProfileSectionItem(
          title: l10n.profileAppearanceTitle,
          subtitle: _themeModeSubtitle(context, settings.themeMode),
          icon: _themeModeIcon(settings.themeMode),
          onPressed: onAppearancePressed,
        ),
        ProfileSectionItem(
          title: l10n.profileLanguageTitle,
          subtitle: isArabicLocale
              ? l10n.profileLanguageArabicSubtitle
              : l10n.profileLanguageEnglishSubtitle,
          icon: Icons.language_rounded,
          onPressed: onLanguagePressed,
          trailing: ProfileCodeBadge(label: isArabicLocale ? 'AR' : 'EN'),
        ),
        ProfileSectionItem(
          title: l10n.profileLocationStatusTitle,
          subtitle: l10n.profileLocationStatusSubtitle,
          icon: Icons.location_on_rounded,
          onPressed: onLocationStatusPressed,
        ),
      ],
    );
  }

  String _themeModeSubtitle(BuildContext context, ThemeMode themeMode) {
    final l10n = context.l10n;

    return switch (themeMode) {
      ThemeMode.system => l10n.profileAppearanceSystemTitle,
      ThemeMode.light => l10n.profileAppearanceLightTitle,
      ThemeMode.dark => l10n.profileAppearanceDarkTitle,
    };
  }

  IconData _themeModeIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
  }
}
