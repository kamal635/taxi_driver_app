import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_text_button.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Email input field
        AppTextField(
          controller: emailController,
          labelText: context.l10n.emailLabel,
          hintText: context.l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.email),
        ),

        AppSpacing.h16,

        /// Password input field with visibility toggle
        AppTextField(
          controller: passwordController,
          labelText: context.l10n.passwordLabel,
          hintText: context.l10n.passwordHint,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onTogglePasswordVisibility,
            icon: Icon(
              obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
            ),
          ),
        ),

        AppSpacing.h24,

        /// Sign in button
        AppButton(
          label: context.l10n.signIn,
          onPressed: () {
            // UI only for now (no logic yet)
          },
        ),

        AppSpacing.h12,

        /// Forgot password text button
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
