import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.h18,
        Image.asset(
          'assets/images/logo_taxi_driver.png',
          height: 112.r,
          width: 112.r,
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
