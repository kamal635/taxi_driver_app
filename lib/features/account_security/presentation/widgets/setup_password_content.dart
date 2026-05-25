import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/widgets/setup_password_form_card.dart';
import 'package:flutter/material.dart';

class SetupPasswordContent extends StatelessWidget {
  const SetupPasswordContent({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isNewPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    super.key,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          isNewPasswordObscured: isNewPasswordObscured,
          isConfirmPasswordObscured: isConfirmPasswordObscured,
          onToggleNewPasswordVisibility: onToggleNewPasswordVisibility,
          onToggleConfirmPasswordVisibility: onToggleConfirmPasswordVisibility,
        ),
      ],
    );
  }
}
