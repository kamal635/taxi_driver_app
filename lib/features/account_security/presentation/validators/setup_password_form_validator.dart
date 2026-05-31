import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/validation/password_form_validator.dart';
import 'package:flutter/widgets.dart';

/// Feature-specific adapter around the shared password validator.
abstract final class SetupPasswordFormValidator {
  static String? validatePassword(BuildContext context, String? value) {
    return PasswordFormValidator.validatePassword(
      value: value,
      requiredMessage: context.l10n.validationPasswordRequired,
      tooShortMessage: context.l10n.authPasswordRulesHint,
    );
  }

  static String? validateConfirmation(
    BuildContext context, {
    required String? value,
    required String password,
  }) {
    return PasswordFormValidator.validateConfirmation(
      value: value,
      password: password,
      requiredMessage: context.l10n.validationPasswordRequired,
      tooShortMessage: context.l10n.authPasswordRulesHint,
      mismatchMessage: context.l10n.errorValidation,
    );
  }
}
