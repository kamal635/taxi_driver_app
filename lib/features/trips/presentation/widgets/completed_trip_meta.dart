import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/completed_trip_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedTripMeta extends StatelessWidget {
  const CompletedTripMeta({
    required this.offer,
    super.key,
  });

  final CompletedOfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final price = formatOrderPrice(offer.price);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 108.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            CompletedTripTimeFormatter.format(context, offer.updatedAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitleSm.copyWith(
              color: AppColors.iconMuted,
              fontSize: 10.sp,
            ),
          ),
          AppSpacing.h12,
          Text(
            '${context.l10n.currencySyrianPound} $price',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitleMd.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
