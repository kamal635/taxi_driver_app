import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_fields_group.dart';
import 'package:flutter/material.dart';

/// Password fields used by the profile password change screen.
class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.newPasswordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.enabled,
    required this.onValidateNewPassword,
    required this.onValidateConfirmPassword,
    this.onPasswordSubmitted,
    this.onConfirmPasswordSubmitted,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode newPasswordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final ValueChanged<String>? onPasswordSubmitted;
  final ValueChanged<String>? onConfirmPasswordSubmitted;
  final bool enabled;
  final FormFieldValidator<String> onValidateNewPassword;
  final FormFieldValidator<String> onValidateConfirmPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AutofillGroup(
      child: PasswordFieldsGroup(
        passwordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
        passwordFocusNode: newPasswordFocusNode,
        confirmPasswordFocusNode: confirmPasswordFocusNode,
        enabled: enabled,
        passwordLabel: l10n.profileNewPassword,
        confirmPasswordLabel: l10n.profileConfirmNewPassword,
        hintText: l10n.passwordHint,
        isPasswordObscured: obscureNewPassword,
        isConfirmPasswordObscured: obscureConfirmPassword,
        onTogglePasswordVisibility: onToggleNewPasswordVisibility,
        onToggleConfirmPasswordVisibility: onToggleConfirmPasswordVisibility,
        onPasswordSubmitted: onPasswordSubmitted,
        onConfirmPasswordSubmitted: onConfirmPasswordSubmitted,
        passwordValidator: onValidateNewPassword,
        confirmPasswordValidator: onValidateConfirmPassword,
      ),
    );
  }
}
