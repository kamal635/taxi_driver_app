import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

class LocationStatusErrorCard extends StatelessWidget {
  const LocationStatusErrorCard({
    required this.isBusy,
    required this.onRefreshPressed,
    super.key,
  });

  final bool isBusy;
  final VoidCallback onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.locationStatusCheckFailedTitle,
            style: AppTypography.labelMd.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.h8,
          Text(
            context.l10n.locationStatusCheckFailedSubtitle,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.h16,
          AppButton(
            label: context.l10n.locationStatusRefreshAction,
            isLoading: isBusy,
            onPressed: isBusy ? null : onRefreshPressed,
          ),
        ],
      ),
    );
  }
}
