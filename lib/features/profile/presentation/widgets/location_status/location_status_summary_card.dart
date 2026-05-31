import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_summary_icon.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

class LocationStatusSummaryCard extends StatelessWidget {
  const LocationStatusSummaryCard({required this.isReady, super.key});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LocationStatusSummaryIcon(isReady: isReady),
              AppSpacing.w12,
              Expanded(
                child: Text(
                  isReady
                      ? l10n.locationStatusReadyTitle
                      : l10n.locationStatusNeedsAttentionTitle,
                  style: AppTypography.labelMd.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h10,
          Text(
            l10n.locationStatusWhyMessage,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
