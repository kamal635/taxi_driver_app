import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/change_password/change_password_form.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({
    required this.formKey,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.newPasswordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.enabled,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onValidateNewPassword,
    required this.onValidateConfirmPassword,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode newPasswordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final bool enabled;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final FormFieldValidator<String> onValidateNewPassword;
  final FormFieldValidator<String> onValidateConfirmPassword;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangePasswordForm(
              newPasswordController: newPasswordController,
              confirmPasswordController: confirmPasswordController,
              newPasswordFocusNode: newPasswordFocusNode,
              confirmPasswordFocusNode: confirmPasswordFocusNode,
              obscureNewPassword: obscureNewPassword,
              obscureConfirmPassword: obscureConfirmPassword,
              onToggleNewPasswordVisibility: onToggleNewPasswordVisibility,
              onToggleConfirmPasswordVisibility:
                  onToggleConfirmPasswordVisibility,
              onPasswordSubmitted: (_) =>
                  confirmPasswordFocusNode.requestFocus(),
              onConfirmPasswordSubmitted: (_) => unawaited(onSubmit()),
              onValidateNewPassword: onValidateNewPassword,
              onValidateConfirmPassword: onValidateConfirmPassword,
              enabled: enabled,
            ),
            AppSpacing.h12,
            Text(
              context.l10n.profilePasswordHint,
              style: AppTypography.subtitleSm,
            ),
          ],
        ),
      ),
    );
  }
}
