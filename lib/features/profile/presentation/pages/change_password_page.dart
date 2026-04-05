import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/change_password_form.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_card_surface.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenToSubmitState();

    final l10n = context.l10n;
    final submitState = ref.watch(setupPasswordControllerProvider);
    final isSubmitting = submitState.isLoading;

    return AppOverlayScaffold(
      title: l10n.profileChangePasswordTitle,
      bottom: AppButton(
        label: l10n.profileUpdatePasswordAction,
        isLoading: isSubmitting,
        onPressed: isSubmitting ? null : _submit,
      ),
      child: ProfileCardSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangePasswordForm(
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
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
              enabled: !isSubmitting,
            ),
            AppSpacing.h12,
            Text(
              l10n.profilePasswordHint,
              style: AppTypography.subtitleSm,
            ),
          ],
        ),
      ),
    );
  }

  void _listenToSubmitState() {
    ref.listen(setupPasswordControllerProvider, (previous, next) async {
      await next.whenOrNull(
        error: (error, _) {
          final message = failureToUserMessage(
            error,
            l10n: context.l10n,
          );
          context.showAppSnack(message, type: AppSnackType.error);
        },
        data: (message) async {
          if (message == null || message.isEmpty) return;
          if (message == previous?.value) return;

          context.showAppSnack(message, type: AppSnackType.success);
          ref.read(setupPasswordControllerProvider.notifier).reset();

          if (context.mounted) {
            context.pop();
          }
        },
      );
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      context.showAppSnack(
        l10n.authPasswordRulesHint,
        type: AppSnackType.error,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      context.showAppSnack(
        l10n.errorValidation,
        type: AppSnackType.error,
      );
      return;
    }

    await ref.read(setupPasswordControllerProvider.notifier).submit(
          newPassword: newPassword,
        );
  }
}
