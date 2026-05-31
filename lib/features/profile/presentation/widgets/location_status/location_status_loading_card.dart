import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationStatusLoadingCard extends StatelessWidget {
  const LocationStatusLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      child: Row(
        children: [
          SizedBox.square(
            dimension: 22.r,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              context.l10n.locationStatusChecking,
              style: AppTypography.subtitleSm.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
