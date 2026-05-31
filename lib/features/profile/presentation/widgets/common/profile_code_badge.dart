import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCodeBadge extends StatelessWidget {
  const ProfileCodeBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.colors.backgroundDecorative,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: AppTypography.labelSm.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
