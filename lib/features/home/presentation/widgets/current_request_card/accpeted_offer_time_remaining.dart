import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class TimeRemainingBar extends StatelessWidget {
  const TimeRemainingBar({
    required this.remaining,
    required this.progress,
    super.key,
  });

  final Duration remaining;
  final double progress;

  String _mmss(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
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
              _mmss(remaining),
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
