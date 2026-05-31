import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/widgets/form/setup_password_form_card.dart';
import 'package:flutter/material.dart';

class SetupPasswordContent extends StatelessWidget {
  const SetupPasswordContent({
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
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.authSetupPasswordSubtitle,
            style: AppTypography.subtitleMd,
          ),
          AppSpacing.h12,
          SetupPasswordFormCard(
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
            newPasswordFocusNode: newPasswordFocusNode,
            confirmPasswordFocusNode: confirmPasswordFocusNode,
            isSubmitting: isSubmitting,
            isNewPasswordObscured: isNewPasswordObscured,
            isConfirmPasswordObscured: isConfirmPasswordObscured,
            onNewPasswordSubmitted: onNewPasswordSubmitted,
            onConfirmPasswordSubmitted: onConfirmPasswordSubmitted,
            onValidatePassword: onValidatePassword,
            onValidateConfirmPassword: onValidateConfirmPassword,
            onToggleNewPasswordVisibility: onToggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility:
                onToggleConfirmPasswordVisibility,
          ),
        ],
      ),
    );
  }
}
