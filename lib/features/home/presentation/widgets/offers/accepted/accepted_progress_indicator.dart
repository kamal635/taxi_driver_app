import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
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

  String _formatRemaining(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final minutes = safeDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = safeDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              _formatRemaining(remaining),
              style: AppTypography.titleSm.copyWith(
                fontSize: 16.sp,
                color: AppColors.error,
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
            backgroundColor: AppColors.error,
            valueColor: const AlwaysStoppedAnimation(AppColors.border),
          ),
        ),
      ],
    );
  }
}
