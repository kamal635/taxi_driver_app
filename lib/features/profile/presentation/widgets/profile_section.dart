import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    required this.sectionTitle,
    required this.items,
    super.key,
  });
  final List<Widget> items;
  final String sectionTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// section title
        Text(
          sectionTitle,
          style: AppTypography.subtitleSm.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w900,
          ),
        ),

        AppSpacing.h10,

        /// section content
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}
