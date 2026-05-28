import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/home/presentation/utils/offer_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Visual countdown and progress bar for the accepted offer cooldown.
class AcceptedProgressIndicator extends StatelessWidget {
  const AcceptedProgressIndicator({
    required this.remaining,
    required this.progress,
    super.key,
  });

  final Duration remaining;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.timeRemaining,
                style: AppTypography.titleSm.copyWith(fontSize: 16.sp),
              ),
            ),
            Text(
              formatOfferCountdown(remaining),
              style: AppTypography.titleSm.copyWith(
                fontSize: 16.sp,
                color: colors.error,
              ),
            ),
          ],
        ),
        AppSpacing.h12,
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10.h,
            backgroundColor: colors.error.withValues(alpha: 0.22),
            valueColor: AlwaysStoppedAnimation(colors.error),
          ),
        ),
      ],
    );
  }
}
