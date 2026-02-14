import 'package:flutter/material.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_text_button.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    super.key,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;

  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: phoneController,
          labelText: context.l10n.phoneNumberLabel,
          hintText: context.l10n.phoneHint,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          suffixIcon: const Icon(AppIcons.phone),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: passwordController,
          labelText: context.l10n.passwordLabel,
          hintText: context.l10n.passwordHint,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          suffixIcon: const Icon(AppIcons.lock),
          prefixIcon: IconButton(
            onPressed: onTogglePasswordVisibility,
            icon: Icon(obscurePassword ? AppIcons.eye : AppIcons.eyeOff),
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: context.l10n.signIn,
          onPressed: () {
            // UI only for now (no logic yet)
          },
        ),
        const SizedBox(height: 12),
        AppTextButton(
          label: context.l10n.forgotPassword,
          onPressed: () {
            // later
          },
        ),
      ],
    );
  }
}
