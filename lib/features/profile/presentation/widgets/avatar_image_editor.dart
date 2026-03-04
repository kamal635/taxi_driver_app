import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class AvatarImageEditor extends StatelessWidget {
  const AvatarImageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: 92.r,
          height: 92.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.55),
              width: 3,
            ),
            color: AppColors.bgBase,
          ),
          alignment: Alignment.center,
          child: Text(
            'A',
            style: AppTypography.titleSm.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Positioned(
          left: 2.w,
          bottom: 2.h,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              /// later: pick image
            },
            child: Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 18.r,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
