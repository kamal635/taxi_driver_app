import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

/// Password inputs used by the profile password change screen.
class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.enabled,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: newPasswordController,
          enabled: enabled,
          labelText: context.l10n.profileNewPassword,
          hintText: context.l10n.passwordHint,
          obscureText: obscureNewPassword,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onToggleNewPasswordVisibility,
            icon: Icon(
              obscureNewPassword ? AppIcons.eye : AppIcons.eyeOff,
            ),
          ),
        ),
        AppSpacing.h12,
        AppTextField(
          controller: confirmPasswordController,
          enabled: enabled,
          labelText: context.l10n.profileConfirmNewPassword,
          hintText: context.l10n.passwordHint,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onToggleConfirmPasswordVisibility,
            icon: Icon(
              obscureConfirmPassword ? AppIcons.eye : AppIcons.eyeOff,
            ),
          ),
        ),
      ],
    );
  }
}
