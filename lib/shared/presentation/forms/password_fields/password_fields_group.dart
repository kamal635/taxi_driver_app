import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_visibility_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/fields/app_text_field.dart';
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
    this.passwordValidator,
    this.confirmPasswordValidator,
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
  final ValueChanged<String>? onPasswordSubmitted;
  final ValueChanged<String>? onConfirmPasswordSubmitted;
  final FormFieldValidator<String>? passwordValidator;
  final FormFieldValidator<String>? confirmPasswordValidator;
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
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.lock),
          autofillHints: const [AutofillHints.newPassword],
          autocorrect: false,
          enableSuggestions: false,
          validator: passwordValidator,
          suffixIcon: PasswordVisibilityButton(
            isObscured: isPasswordObscured,
            onPressed: onTogglePasswordVisibility,
          ),
          onFieldSubmitted: onPasswordSubmitted,
        ),
        AppSpacing.h14,
        AppTextField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          enabled: enabled,
          obscureText: isConfirmPasswordObscured,
          labelText: confirmPasswordLabel,
          hintText: hintText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          autofillHints: const [AutofillHints.newPassword],
          autocorrect: false,
          enableSuggestions: false,
          validator: confirmPasswordValidator,
          suffixIcon: PasswordVisibilityButton(
            isObscured: isConfirmPasswordObscured,
            onPressed: onToggleConfirmPasswordVisibility,
          ),
          onFieldSubmitted: onConfirmPasswordSubmitted,
        ),
      ],
    );
  }
}
