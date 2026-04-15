import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/listeners/change_password_state_listener.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/change_password_form.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_card_surface.dart';
import 'package:taxi_driver_app/shared/presentation/validation/password_form_validator.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
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
    final isSubmitting = ref.watch(
      setupPasswordControllerProvider.select((state) => state.isLoading),
    );

    return Stack(
      children: [
        AppOverlayScaffold(
          title: context.l10n.profileChangePasswordTitle,
          bottom: AppButton(
            label: context.l10n.profileUpdatePasswordAction,
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
                  context.l10n.profilePasswordHint,
                  style: AppTypography.subtitleSm,
                ),
              ],
            ),
          ),
        ),
        const ChangePasswordStateListener(),
      ],
    );
  }

  Future<void> _submit() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final validationMessage = PasswordFormValidator.validate(
      password: newPassword,
      confirmPassword: confirmPassword,
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
        .submit(newPassword: newPassword);
  }
}
