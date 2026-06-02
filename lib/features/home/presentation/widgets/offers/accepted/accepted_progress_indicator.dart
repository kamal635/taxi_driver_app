import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/home/presentation/formatters/offer_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Visual countdown and progress bar for the accepted offer cooldown.
///
/// Rendered as a flat section inside
/// the main offer card to reduce visual noise.
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.timeRemaining,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSm.copyWith(
                  color: colors.textPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              formatOfferCountdown(remaining),
              style: AppTypography.titleSm.copyWith(
                color: colors.error,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9.h,
            backgroundColor: colors.error.withValues(alpha: 0.18),
            valueColor: AlwaysStoppedAnimation(colors.error),
          ),
        ),
      ],
    );
  }
}
