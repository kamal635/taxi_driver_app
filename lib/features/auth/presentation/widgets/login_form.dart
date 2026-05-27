import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_text_field.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_visibility_button.dart';
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
          AppTextField(
            autofillHints: const [
              AutofillHints.telephoneNumber,
              AutofillHints.username,
            ],
            controller: phoneController,
            labelText: l10n.phoneLabel,
            hintText: l10n.phoneHint,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(AppIcons.phone),
            validator: (value) => _requiredValidator(
              value,
              message: l10n.validationPhoneRequired,
            ),
          ),
          AppSpacing.h16,
          AppTextField(
            autofillHints: const [AutofillHints.password],
            controller: passwordController,
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(AppIcons.lock),
            suffixIcon: PasswordVisibilityButton(
              isObscured: obscurePassword,
              onPressed: onTogglePasswordVisibility,
            ),
            validator: (value) => _requiredValidator(
              value,
              message: l10n.validationPasswordRequired,
            ),
            onFieldSubmitted: (_) {
              if (!isLoading) {
                onSubmit?.call();
              }
            },
            autocorrect: false,
            enableSuggestions: false,
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

  String? _requiredValidator(String? value, {required String message}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }
}
