import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/widgets/app_text_field.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_visibility_button.dart';
import 'package:flutter/material.dart';

/// Reusable two-field password block used by password setup/update screens.
class PasswordFieldsGroup extends StatelessWidget {
  const PasswordFieldsGroup({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordLabel,
    required this.confirmPasswordLabel,
    required this.hintText,
    required this.isPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    this.passwordFocusNode,
    this.confirmPasswordFocusNode,
    this.onPasswordSubmitted,
    this.onConfirmPasswordSubmitted,
    this.enabled = true,
    super.key,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String passwordLabel;
  final String confirmPasswordLabel;
  final String hintText;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final FocusNode? passwordFocusNode;
  final FocusNode? confirmPasswordFocusNode;
  final VoidCallback? onPasswordSubmitted;
  final VoidCallback? onConfirmPasswordSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          enabled: enabled,
          obscureText: isPasswordObscured,
          labelText: passwordLabel,
          hintText: hintText,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.lock),
          autofillHints: const [AutofillHints.newPassword],
          autocorrect: false,
          enableSuggestions: false,
          suffixIcon: PasswordVisibilityButton(
            isObscured: isPasswordObscured,
            onPressed: onTogglePasswordVisibility,
          ),
          onFieldSubmitted: (_) => onPasswordSubmitted?.call(),
        ),
        AppSpacing.h12,
        AppTextField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          enabled: enabled,
          obscureText: isConfirmPasswordObscured,
          labelText: confirmPasswordLabel,
          hintText: hintText,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          autofillHints: const [AutofillHints.newPassword],
          autocorrect: false,
          enableSuggestions: false,
          suffixIcon: PasswordVisibilityButton(
            isObscured: isConfirmPasswordObscured,
            onPressed: onToggleConfirmPasswordVisibility,
          ),
          onFieldSubmitted: (_) => onConfirmPasswordSubmitted?.call(),
        ),
      ],
    );
  }
}
