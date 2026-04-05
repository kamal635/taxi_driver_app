import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

/// Card that contains the new password and confirm password inputs.
class SetupPasswordFormCard extends StatelessWidget {
  const SetupPasswordFormCard({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isNewPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: newPasswordController,
            obscureText: isNewPasswordObscured,
            labelText: context.l10n.authNewPasswordLabel,
            hintText: context.l10n.passwordHint,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(AppIcons.lock),
            suffixIcon: IconButton(
              color: AppColors.iconMuted,
              onPressed: onToggleNewPasswordVisibility,
              icon: Icon(
                isNewPasswordObscured ? AppIcons.eye : AppIcons.eyeOff,
              ),
            ),
          ),
          AppSpacing.h12,
          AppTextField(
            controller: confirmPasswordController,
            obscureText: isConfirmPasswordObscured,
            labelText: context.l10n.authConfirmNewPasswordLabel,
            hintText: context.l10n.passwordHint,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(AppIcons.lock),
            suffixIcon: IconButton(
              color: AppColors.iconMuted,
              onPressed: onToggleConfirmPasswordVisibility,
              icon: Icon(
                isConfirmPasswordObscured ? AppIcons.eye : AppIcons.eyeOff,
              ),
            ),
          ),
          AppSpacing.h12,
          Text(
            context.l10n.authPasswordRulesHint,
            style: AppTypography.subtitleSm,
          ),
        ],
      ),
    );
  }
}
