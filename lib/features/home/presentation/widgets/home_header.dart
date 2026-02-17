import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.appName,
    required this.avatarText,
    required this.onBellPressed,
    super.key,
  });

  final String appName;
  final String avatarText;
  final VoidCallback onBellPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Bell Icon
        IconButton(
          onPressed: onBellPressed,
          icon: Icon(
            Icons.notifications_none_rounded,
            size: 22.r,
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        /// App Name
        Text(appName, style: AppTypography.titleSm),

        const Spacer(),

        /// Status Pill
        _Avatar(text: avatarText),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.taxiYellow, width: 2),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          text,
          style: AppTypography.labelMd.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
