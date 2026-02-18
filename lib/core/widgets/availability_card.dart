import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/widgets/status_pill.dart';

class AvailabilityCard extends StatelessWidget {
  const AvailabilityCard({
    required this.isOnline,
    required this.title,
    required this.subtitle,
    required this.textPill,
    required this.onChanged,
    super.key,
  });

  final bool isOnline;
  final String title;
  final String subtitle;
  final String textPill;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSm),

                AppSpacing.h6,

                Text(subtitle, style: AppTypography.bodyMuted),
              ],
            ),
          ),

          AppSpacing.w12,

          /// Switch
          Column(
            children: [
              StatusPill(text: textPill, isOnline: isOnline),
              AppSpacing.h12,
              Switch(
                value: isOnline,
                onChanged: onChanged,
                activeTrackColor: AppColors.taxiYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
