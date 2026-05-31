import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingOfferFareCard extends StatelessWidget {
  const PendingOfferFareCard({
    required this.totalFare,
    super.key,
  });

  final String totalFare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.34),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.payments_rounded,
              size: 26.r,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalFare,
                  style: AppTypography.labelMd.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                FittedBox(
                  alignment: AlignmentDirectional.centerStart,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${formatOrderPrice(totalFare)} '
                    '${l10n.currencySyrianPound}',
                    maxLines: 1,
                    style: AppTypography.titleMd.copyWith(
                      fontSize: 30.sp,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
