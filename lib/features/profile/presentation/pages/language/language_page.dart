import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Language selection screen shown from the profile section.
class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(appSettingsProvider);
    final isArabicLocale = settings.isArabic;

    return AppOverlayScaffold(
      title: l10n.profileLanguageTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileLanguagePageSubtitle,
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
                  title: l10n.profileLanguageArabicSubtitle,
                  subtitle: l10n.profileLanguageArabicOptionSubtitle,
                  icon: Icons.format_textdirection_r_to_l_rounded,
                  onPressed: () => _selectArabicLocale(context, ref),
                  trailing: isArabicLocale
                      ? const _SelectedLanguageIcon()
                      : const _LanguageCodeBadge(label: 'AR'),
                ),
                ProfileSectionItem(
                  title: l10n.profileLanguageEnglishSubtitle,
                  subtitle: l10n.profileLanguageEnglishOptionSubtitle,
                  icon: Icons.format_textdirection_l_to_r_rounded,
                  onPressed: () => _selectEnglishLocale(context, ref),
                  trailing: !isArabicLocale
                      ? const _SelectedLanguageIcon()
                      : const _LanguageCodeBadge(label: 'EN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectArabicLocale(BuildContext context, WidgetRef ref) async {
    await ref.read(appSettingsControllerProvider).setArabicLocale();

    if (!context.mounted) return;

    Navigator.of(context).pop();
  }

  Future<void> _selectEnglishLocale(BuildContext context, WidgetRef ref) async {
    await ref.read(appSettingsControllerProvider).setEnglishLocale();

    if (!context.mounted) return;

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

class _LanguageCodeBadge extends StatelessWidget {
  const _LanguageCodeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.colors.backgroundDecorative,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: AppTypography.labelSm.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
