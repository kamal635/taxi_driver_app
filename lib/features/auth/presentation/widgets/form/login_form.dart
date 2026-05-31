import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/form/login_password_field.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/form/login_phone_field.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

/// Login form widget that delegates submission and UI state to the parent page.
class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final bool isLoading;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        children: [
          LoginPhoneField(controller: phoneController),
          AppSpacing.h16,
          LoginPasswordField(
            controller: passwordController,
            obscurePassword: obscurePassword,
            onTogglePasswordVisibility: onTogglePasswordVisibility,
            isLoading: isLoading,
            onSubmit: onSubmit,
          ),
          AppSpacing.h24,
          AppButton(
            label: l10n.signIn,
            onPressed: isLoading ? null : onSubmit,
            isLoading: isLoading,
          ),
          AppSpacing.h12,
        ],
      ),
    );
  }
}
