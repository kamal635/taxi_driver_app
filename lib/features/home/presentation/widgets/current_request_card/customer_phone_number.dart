import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class CustomerPhoneNumber extends StatelessWidget {
  const CustomerPhoneNumber({required this.customerPhone, super.key});

  final String customerPhone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const Divider(
          color: AppColors.iconMuted,
          height: 1,
        ),

        AppSpacing.h12,

        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcons.phone,
                    color: AppColors.primary,
                    size: 28.r,
                  ),
                ),

                AppSpacing.w12,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerPhone,
                        style: AppTypography.titleSm.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        l10n.tapToCall,
                        style: AppTypography.subtitleMd,
                      ),
                    ],
                  ),
                ),

                Icon(
                  AppIcons.arrowf,
                  color: AppColors.iconMuted,
                  size: 18.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
