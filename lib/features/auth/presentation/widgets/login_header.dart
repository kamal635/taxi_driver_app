import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.h),
        Container(
          width: 72.w,
          height: 72.w,
          decoration: const BoxDecoration(
            color: AppColors.taxiYellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.taxi,
            size: 34.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          context.l10n.brandName,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          context.l10n.brandSubtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 26.h),
      ],
    );
  }
}
