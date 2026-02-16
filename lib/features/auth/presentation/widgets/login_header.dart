import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.h18,

        /// Logo in a circular container
        Container(
          width: 72.w,
          height: 72.w,
          decoration: const BoxDecoration(
            color: AppColors.taxiYellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.taxi,
            size: 34.w,
            color: AppColors.textPrimary,
          ),
        ),

        AppSpacing.h14,

        /// Brand name text
        Text(
          context.l10n.brandName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleLg,
        ),

        AppSpacing.h10,

        /// Subtitle text below the brand name
        Text(
          context.l10n.brandSubtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.subtitleMd,
        ),

        AppSpacing.h24,
      ],
    );
  }
}
