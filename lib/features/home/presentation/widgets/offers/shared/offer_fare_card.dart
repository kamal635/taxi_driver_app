import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _fareAmountColor = Color(0xFF16A34A);

/// Shared fare block used by all offer states.
///
/// This is intentionally not styled as a nested card. The parent offer card is
/// already the main surface, so the fare is presented as a strong hero row to
/// keep the UI cleaner and lighter.
class OfferFareCard extends StatelessWidget {
  const OfferFareCard({
    required this.totalFare,
    super.key,
  });

  final String totalFare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.payments_rounded,
              size: 28.r,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalFare,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w800,
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
                      fontSize: 34.sp,
                      color: _fareAmountColor,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
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
