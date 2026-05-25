import 'dart:async';

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
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
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _newPasswordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  ProviderSubscription<AsyncValue<String?>>? _submitSubscription;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    _submitSubscription = ref.listenManual<AsyncValue<String?>>(
      setupPasswordControllerProvider,
      _handleSubmitStateChanged,
    );
  }

  Future<void> _handleSubmitStateChanged(
    AsyncValue<String?>? previous,
    AsyncValue<String?> next,
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
      data: (message) async {
        if (message == null || message.isEmpty || message == previous?.value) {
          return;
        }

        if (!mounted) {
          return;
        }

        context.showAppSnack(message, type: AppSnackType.success);
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
              onToggleNewPasswordVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              onToggleConfirmPasswordVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              onPasswordSubmitted: () {
                _confirmPasswordFocusNode.requestFocus();
              },
              onConfirmPasswordSubmitted: _submit,
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
    );
  }

  Future<void> _submit() async {
    final validationMessage = PasswordFormValidator.validate(
      password: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
      tooShortMessage: context.l10n.authPasswordRulesHint,
      mismatchMessage: context.l10n.errorValidation,
    );

    if (validationMessage != null) {
      context.showAppSnack(
        validationMessage,
        type: AppSnackType.error,
      );
      return;
    }

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: _newPasswordController.text.trim(),
        );
  }
}
