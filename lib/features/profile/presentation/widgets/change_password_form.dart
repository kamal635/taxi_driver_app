import 'package:flutter/material.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/shared/presentation/forms/password_fields/password_fields_group.dart';

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
    return PasswordFieldsGroup(
      passwordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      passwordLabel: context.l10n.profileNewPassword,
      confirmPasswordLabel: context.l10n.profileConfirmNewPassword,
      hintText: context.l10n.passwordHint,
      isPasswordObscured: obscureNewPassword,
      isConfirmPasswordObscured: obscureConfirmPassword,
      onTogglePasswordVisibility: onToggleNewPasswordVisibility,
      onToggleConfirmPasswordVisibility: onToggleConfirmPasswordVisibility,
      enabled: enabled,
    );
  }
}
