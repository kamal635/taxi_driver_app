import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/forms/password_fields/password_fields_group.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupPasswordFormCard extends StatelessWidget {
  const SetupPasswordFormCard({
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
    return AppCardSurface(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordFieldsGroup(
            passwordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
            passwordLabel: context.l10n.authNewPasswordLabel,
            confirmPasswordLabel: context.l10n.authConfirmNewPasswordLabel,
            hintText: context.l10n.passwordHint,
            isPasswordObscured: isNewPasswordObscured,
            isConfirmPasswordObscured: isConfirmPasswordObscured,
            onTogglePasswordVisibility: onToggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility:
                onToggleConfirmPasswordVisibility,
          ),
          AppSpacing.h12,
          Text(
            context.l10n.authPasswordRulesHint,
            style: AppTypography.subtitleSm,
          ),
        ],
      ),
    );
  }
}
