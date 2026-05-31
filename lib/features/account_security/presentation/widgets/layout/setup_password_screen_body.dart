import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/widgets/content/setup_password_content.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:flutter/material.dart';

class SetupPasswordScreenBody extends StatelessWidget {
  const SetupPasswordScreenBody({
    required this.formKey,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.newPasswordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.isSubmitting,
    required this.isNewPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onSubmit,
    required this.onNewPasswordSubmitted,
    required this.onConfirmPasswordSubmitted,
    required this.onValidatePassword,
    required this.onValidateConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode newPasswordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool isSubmitting;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final VoidCallback? onSubmit;
  final ValueChanged<String> onNewPasswordSubmitted;
  final ValueChanged<String> onConfirmPasswordSubmitted;
  final FormFieldValidator<String> onValidatePassword;
  final FormFieldValidator<String> onValidateConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return AppOverlayScaffold(
      title: context.l10n.authSetupPasswordTitle,
      bottom: AppButton(
        isLoading: isSubmitting,
        label: context.l10n.authCreatePasswordAction,
        onPressed: onSubmit,
      ),
      child: Form(
        key: formKey,
        child: SetupPasswordContent(
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
          onToggleConfirmPasswordVisibility: onToggleConfirmPasswordVisibility,
        ),
      ),
    );
  }
}
