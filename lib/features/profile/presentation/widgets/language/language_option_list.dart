import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/common/profile_code_badge.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageOptionList extends ConsumerWidget {
  const LanguageOptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isArabicLocale = ref.watch(
      appSettingsProvider.select((settings) => settings.isArabic),
    );

    return AppCardSurface(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        children: [
          ProfileSectionItem(
            title: l10n.profileLanguageArabicSubtitle,
            subtitle: l10n.profileLanguageArabicOptionSubtitle,
            icon: Icons.format_textdirection_r_to_l_rounded,
            onPressed: () => _selectArabicLocale(context, ref),
            trailing: isArabicLocale
                ? const _SelectedLanguageIcon()
                : const ProfileCodeBadge(label: 'AR'),
          ),
          ProfileSectionItem(
            title: l10n.profileLanguageEnglishSubtitle,
            subtitle: l10n.profileLanguageEnglishOptionSubtitle,
            icon: Icons.format_textdirection_l_to_r_rounded,
            onPressed: () => _selectEnglishLocale(context, ref),
            trailing: !isArabicLocale
                ? const _SelectedLanguageIcon()
                : const ProfileCodeBadge(label: 'EN'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectArabicLocale(BuildContext context, WidgetRef ref) async {
    await ref.read(appSettingsControllerProvider).setArabicLocale();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _selectEnglishLocale(BuildContext context, WidgetRef ref) async {
    await ref.read(appSettingsControllerProvider).setEnglishLocale();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }
}

class _SelectedLanguageIcon extends StatelessWidget {
  const _SelectedLanguageIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle_rounded,
      size: 22.r,
      color: context.colors.primary,
    );
  }
}
