import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_card_surface.dart';

class CompletedTripCard extends StatelessWidget {
  const CompletedTripCard({
    required this.placeTitle,
    required this.timeText,
    required this.fareText,
    super.key,
  });

  final String placeTitle;
  final String timeText;
  final String fareText;

  @override
  Widget build(BuildContext context) {
    return TripsCardSurface(
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.bgBase,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 22.r,
              color: AppColors.iconMuted,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd,
                ),
                AppSpacing.h6,
                Text(
                  timeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subtitleSm,
                ),
              ],
            ),
          ),
          AppSpacing.w12,
          Text(
            fareText,
            style: AppTypography.labelMd.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
