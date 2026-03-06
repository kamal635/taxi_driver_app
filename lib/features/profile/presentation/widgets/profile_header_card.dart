import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/avatar_image_editor.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.name,
    required this.phone,
    required this.placeholderImage,
    super.key,
  });

  final String name;
  final String phone;
  final String placeholderImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          AvatarImageEditor(placeholderImage: placeholderImage),

          AppSpacing.h12,

          Text(name, style: AppTypography.titleSm),
          AppSpacing.h6,
          Text(phone, style: AppTypography.subtitleMd),

          AppSpacing.h12,
        ],
      ),
    );
  }
}
