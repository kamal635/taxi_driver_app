import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController phoneController; // (phone)
  final TextEditingController passwordController;

  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  /// When true, disable submit and (optionally) show loading in the button.
  final bool isLoading;

  /// Trigger sign-in from the parent (LoginPage).
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          autofillHints: const [
            AutofillHints.telephoneNumber,
            AutofillHints.username,
          ],
          controller: phoneController,
          labelText: context.l10n.phoneLabel,
          hintText: context.l10n.phoneHint,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(AppIcons.phone),
        ),
        AppSpacing.h16,
        AppTextField(
          autofillHints: const [AutofillHints.password],
          controller: passwordController,
          labelText: context.l10n.passwordLabel,
          hintText: context.l10n.passwordHint,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(AppIcons.lock),
          suffixIcon: IconButton(
            color: AppColors.iconMuted,
            onPressed: onTogglePasswordVisibility,
            icon: Icon(obscurePassword ? AppIcons.eye : AppIcons.eyeOff),
          ),
        ),
        AppSpacing.h24,

        AppButton(
          label: context.l10n.signIn,
          onPressed: isLoading ? null : onSubmit,
          isLoading: isLoading,
        ),

        AppSpacing.h12,

        // AppTextButton(
        //   label: context.l10n.forgotPassword,
        //   onPressed: () {
        //     // later
        //   },
        // ),
      ],
    );
  }
}
