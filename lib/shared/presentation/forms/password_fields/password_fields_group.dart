import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';
import 'package:taxi_driver_app/shared/presentation/forms/password_fields/password_visibility_button.dart';

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
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: passwordController,
          enabled: enabled,
          obscureText: isPasswordObscured,
          labelText: passwordLabel,
          hintText: hintText,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: PasswordVisibilityButton(
            isObscured: isPasswordObscured,
            onPressed: onTogglePasswordVisibility,
          ),
        ),
        AppSpacing.h12,
        AppTextField(
          controller: confirmPasswordController,
          enabled: enabled,
          obscureText: isConfirmPasswordObscured,
          labelText: confirmPasswordLabel,
          hintText: hintText,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: PasswordVisibilityButton(
            isObscured: isConfirmPasswordObscured,
            onPressed: onToggleConfirmPasswordVisibility,
          ),
        ),
      ],
    );
  }
}
