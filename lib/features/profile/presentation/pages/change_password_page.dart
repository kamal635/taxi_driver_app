import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_result.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/change_password/change_password_form.dart';
import 'package:bawabat_al_saeq/shared/presentation/validation/password_form_validator.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
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

  ProviderSubscription<AsyncValue<SetupPasswordResult?>>? _submitSubscription;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    _submitSubscription = ref.listenManual<AsyncValue<SetupPasswordResult?>>(
      setupPasswordControllerProvider,
      _handleSubmitStateChanged,
    );
  }

  Future<void> _handleSubmitStateChanged(
    AsyncValue<SetupPasswordResult?>? previous,
    AsyncValue<SetupPasswordResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!mounted) {
          return;
        }

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (result) async {
        if (result == null ||
            result.submissionId == previous?.asData?.value?.submissionId) {
          return;
        }

        if (!mounted) {
          return;
        }

        context.showAppSnack(
          result.message ?? context.l10n.profilePasswordUpdatedSuccess,
          type: AppSnackType.success,
        );
        ref.read(setupPasswordControllerProvider.notifier).reset();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _submitSubscription?.close();
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
      child: AppCardSurface(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChangePasswordForm(
                newPasswordController: _newPasswordController,
                confirmPasswordController: _confirmPasswordController,
                newPasswordFocusNode: _newPasswordFocusNode,
                confirmPasswordFocusNode: _confirmPasswordFocusNode,
                obscureNewPassword: _obscureNewPassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                onToggleNewPasswordVisibility: _toggleNewPasswordVisibility,
                onToggleConfirmPasswordVisibility:
                    _toggleConfirmPasswordVisibility,
                onPasswordSubmitted: (_) {
                  _confirmPasswordFocusNode.requestFocus();
                },
                onConfirmPasswordSubmitted: (_) {
                  unawaited(_submit());
                },
                onValidateNewPassword: _validateNewPassword,
                onValidateConfirmPassword: _validateConfirmPassword,
                enabled: !isSubmitting,
              ),
              AppSpacing.h12,
              Text(
                context.l10n.profilePasswordHint,
                style: AppTypography.subtitleSm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
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
