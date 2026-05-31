import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/listeners/change_password_state_listener.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/change_password/change_password_body.dart';
import 'package:bawabat_al_saeq/shared/presentation/validation/password_form_validator.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Password update screen shown from the profile section.
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _newPasswordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      setupPasswordControllerProvider.select((state) => state.isLoading),
    );

    return AppOverlayScaffold(
      title: context.l10n.profileChangePasswordTitle,
      bottom: AppButton(
        label: context.l10n.profileUpdatePasswordAction,
        isLoading: isSubmitting,
        onPressed: isSubmitting ? null : _submit,
      ),
      child: Column(
        children: [
          const ChangePasswordStateListener(),
          ChangePasswordBody(
            formKey: _formKey,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            newPasswordFocusNode: _newPasswordFocusNode,
            confirmPasswordFocusNode: _confirmPasswordFocusNode,
            obscureNewPassword: _obscureNewPassword,
            obscureConfirmPassword: _obscureConfirmPassword,
            enabled: !isSubmitting,
            onToggleNewPasswordVisibility: _toggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
            onValidateNewPassword: _validateNewPassword,
            onValidateConfirmPassword: _validateConfirmPassword,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  void _toggleNewPasswordVisibility() {
    setState(() => _obscureNewPassword = !_obscureNewPassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  String? _validateNewPassword(String? value) {
    return PasswordFormValidator.validatePassword(
      value: value,
      requiredMessage: context.l10n.validationPasswordRequired,
      tooShortMessage: context.l10n.authPasswordRulesHint,
    );
  }

  String? _validateConfirmPassword(String? value) {
    return PasswordFormValidator.validateConfirmation(
      value: value,
      password: _newPasswordController.text,
      requiredMessage: context.l10n.validationPasswordRequired,
      tooShortMessage: context.l10n.authPasswordRulesHint,
      mismatchMessage: context.l10n.profilePasswordMismatch,
    );
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: _newPasswordController.text.trim(),
        );
  }
}
