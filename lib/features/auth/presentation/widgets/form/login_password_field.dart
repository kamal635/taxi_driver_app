import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/validators/login_form_validator.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_visibility_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/fields/app_text_field.dart';
import 'package:flutter/material.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({
    required this.controller,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final bool isLoading;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppTextField(
      autofillHints: const [AutofillHints.password],
      controller: controller,
      labelText: l10n.passwordLabel,
      hintText: l10n.passwordHint,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(AppIcons.lock),
      suffixIcon: PasswordVisibilityButton(
        isObscured: obscurePassword,
        onPressed: onTogglePasswordVisibility,
      ),
      validator: (value) => LoginFormValidator.requiredField(
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
    );
  }
}
