import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_fields_group.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

class SetupPasswordFormCard extends StatelessWidget {
  const SetupPasswordFormCard({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.newPasswordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.isSubmitting,
    required this.isNewPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onNewPasswordSubmitted,
    required this.onConfirmPasswordSubmitted,
    required this.onValidatePassword,
    required this.onValidateConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode newPasswordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool isSubmitting;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final ValueChanged<String> onNewPasswordSubmitted;
  final ValueChanged<String> onConfirmPasswordSubmitted;
  final FormFieldValidator<String> onValidatePassword;
  final FormFieldValidator<String> onValidateConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordFieldsGroup(
            passwordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
            passwordFocusNode: newPasswordFocusNode,
            confirmPasswordFocusNode: confirmPasswordFocusNode,
            enabled: !isSubmitting,
            passwordLabel: l10n.authNewPasswordLabel,
            confirmPasswordLabel: l10n.authConfirmNewPasswordLabel,
            hintText: l10n.passwordHint,
            isPasswordObscured: isNewPasswordObscured,
            isConfirmPasswordObscured: isConfirmPasswordObscured,
            onTogglePasswordVisibility: onToggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility:
                onToggleConfirmPasswordVisibility,
            onPasswordSubmitted: onNewPasswordSubmitted,
            onConfirmPasswordSubmitted: onConfirmPasswordSubmitted,
            passwordValidator: onValidatePassword,
            confirmPasswordValidator: onValidateConfirmPassword,
          ),
          AppSpacing.h12,
          Text(
            l10n.authPasswordRulesHint,
            style: AppTypography.subtitleSm,
          ),
        ],
      ),
    );
  }
}
