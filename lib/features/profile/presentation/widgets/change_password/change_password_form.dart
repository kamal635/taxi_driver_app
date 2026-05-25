import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_fields_group.dart';
import 'package:flutter/material.dart';

/// Password fields used by the profile password change screen.
class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.enabled,
    this.newPasswordFocusNode,
    this.confirmPasswordFocusNode,
    this.onPasswordSubmitted,
    this.onConfirmPasswordSubmitted,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode? newPasswordFocusNode;
  final FocusNode? confirmPasswordFocusNode;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback? onPasswordSubmitted;
  final VoidCallback? onConfirmPasswordSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PasswordFieldsGroup(
      passwordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      passwordFocusNode: newPasswordFocusNode,
      confirmPasswordFocusNode: confirmPasswordFocusNode,
      passwordLabel: context.l10n.profileNewPassword,
      confirmPasswordLabel: context.l10n.profileConfirmNewPassword,
      hintText: context.l10n.passwordHint,
      isPasswordObscured: obscureNewPassword,
      isConfirmPasswordObscured: obscureConfirmPassword,
      onTogglePasswordVisibility: onToggleNewPasswordVisibility,
      onToggleConfirmPasswordVisibility: onToggleConfirmPasswordVisibility,
      onPasswordSubmitted: onPasswordSubmitted,
      onConfirmPasswordSubmitted: onConfirmPasswordSubmitted,
      enabled: enabled,
    );
  }
}
