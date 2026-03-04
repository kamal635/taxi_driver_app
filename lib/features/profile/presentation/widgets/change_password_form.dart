import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.onToggleNewVisibility,
    required this.onToggleConfirmVisibility,
    required this.enabled,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  final bool obscureNew;
  final bool obscureConfirm;

  final VoidCallback onToggleNewVisibility;
  final VoidCallback onToggleConfirmVisibility;

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
          obscureText: obscureNew,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onToggleNewVisibility,
            icon: Icon(obscureNew ? AppIcons.eye : AppIcons.eyeOff),
          ),
        ),

        AppSpacing.h12,

        AppTextField(
          controller: confirmPasswordController,
          enabled: enabled,
          labelText: context.l10n.profileConfirmNewPassword,
          hintText: context.l10n.passwordHint,
          obscureText: obscureConfirm,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onToggleConfirmVisibility,
            icon: Icon(obscureConfirm ? AppIcons.eye : AppIcons.eyeOff),
          ),
        ),
      ],
    );
  }
}
