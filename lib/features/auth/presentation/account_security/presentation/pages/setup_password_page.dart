import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:taxi_driver_app/features/auth/presentation/account_security/presentation/widgets/setup_password_form_card.dart';

class SetupPasswordPage extends ConsumerStatefulWidget {
  const SetupPasswordPage({super.key});

  @override
  ConsumerState<SetupPasswordPage> createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends ConsumerState<SetupPasswordPage> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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
    final setupState = ref.watch(setupPasswordControllerProvider);
    final isLoading = setupState.isLoading;
    final l10n = context.l10n;

    _listenToSetupPasswordState();

    return AppOverlayScaffold(
      title: l10n.authSetupPasswordTitle,
      bottom: AppButton(
        isLoading: isLoading,
        label: l10n.authCreatePasswordAction,
        onPressed: isLoading ? null : _submitPasswordSetup,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.authSetupPasswordSubtitle,
            style: AppTypography.subtitleMd,
          ),
          AppSpacing.h12,
          SetupPasswordFormCard(
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            isNewPasswordObscured: _isNewPasswordObscured,
            isConfirmPasswordObscured: _isConfirmPasswordObscured,
            onToggleNewPasswordVisibility: _toggleNewPasswordVisibility,
            onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
          ),
        ],
      ),
    );
  }

  /// Listens to the setup-password controller and reacts with UI side effects.
  void _listenToSetupPasswordState() {
    final authSessionStore = ref.read(authSessionProvider);

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
          if (message == null || message == previous?.value) {
            return;
          }

          await authSessionStore.markPasswordCreated();

          if (!mounted) {
            return;
          }

          context.showAppSnack(message, type: AppSnackType.success);
          ref.read(setupPasswordControllerProvider.notifier).reset();
          context.go(AppRoutes.home);
        },
      );
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() => _isNewPasswordObscured = !_isNewPasswordObscured);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(
      () => _isConfirmPasswordObscured = !_isConfirmPasswordObscured,
    );
  }

  /// Validates the inputs before calling the controller.
  Future<void> _submitPasswordSetup() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      context.showAppSnack(
        context.l10n.authPasswordRulesHint,
        type: AppSnackType.warning,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      context.showAppSnack(
        context.l10n.errorValidation,
        type: AppSnackType.warning,
      );
      return;
    }

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: newPassword,
        );
  }
}
