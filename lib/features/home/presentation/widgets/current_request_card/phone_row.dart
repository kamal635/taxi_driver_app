import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneRow extends StatelessWidget {
  const PhoneRow({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            AppIcons.phone,
            size: 16.r,
            color: AppColors.primary,
          ),
        ),
        AppSpacing.w4,
        Expanded(child: Text(phoneNumber, style: AppTypography.bodyMd)),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse('tel:$phoneNumber');
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.phone,
              color: AppColors.textPrimary,
              size: 18.r,
            ),
          ),
        ),
      ],
    );
  }
}
