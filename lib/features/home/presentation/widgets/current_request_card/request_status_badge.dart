import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/current_request_card.dart';

class RequestStatusBadge extends StatelessWidget {
  const RequestStatusBadge({
    required this.badgeTitle,
    required this.variant,
    super.key,
  });

  final CardVariant variant;
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    final isOffer = variant == CardVariant.offer;

    final bgColor = isOffer
        ? AppColors.textPrimary.withValues(alpha: 0.1)
        : AppColors.successBg;

    final textColor = isOffer
        ? AppColors.textPrimary.withValues(alpha: 0.8)
        : AppColors.success;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        badgeTitle,
        style: AppTypography.labelMd.copyWith(color: textColor),
      ),
    );
  }
}
