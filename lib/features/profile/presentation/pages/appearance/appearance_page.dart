import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/appearance/appearance_option_list.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:flutter/material.dart';

/// Appearance selection screen shown from the profile section.
class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
          const AppearanceOptionList(),
        ],
      ),
    );
  }
}
