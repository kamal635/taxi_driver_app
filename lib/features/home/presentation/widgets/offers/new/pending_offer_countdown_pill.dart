import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/home/presentation/formatters/offer_time_formatter.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/builders/countdown_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingOfferCountdownPill extends StatelessWidget {
  const PendingOfferCountdownPill({
    required this.expiresAt,
    super.key,
  });

  final DateTime expiresAt;

  @override
  Widget build(BuildContext context) {
    return CountdownBuilder(
      targetTime: expiresAt,
      builder: (context, remaining) {
        return _PendingCountdownPillContent(
          label: formatOfferCountdown(remaining),
        );
      },
    );
  }
}

class _PendingCountdownPillContent extends StatelessWidget {
  const _PendingCountdownPillContent({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.errorBg.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: colors.error.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 17.r,
            color: colors.error,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSm.copyWith(
              color: colors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
