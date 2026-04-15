import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:taxi_driver_app/features/account_security/presentation/widgets/setup_password_content.dart';
import 'package:taxi_driver_app/shared/presentation/validation/password_form_validator.dart';

class SetupPasswordPage extends ConsumerStatefulWidget {
  const SetupPasswordPage({super.key});

  @override
  ConsumerState<SetupPasswordPage> createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends ConsumerState<SetupPasswordPage> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  ProviderSubscription<AsyncValue<String?>>? _submitSubscription;

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _submitSubscription = ref.listenManual<AsyncValue<String?>>(
      setupPasswordControllerProvider,
      _handleSubmitStateChanged,
    );
  }

  @override
  void dispose() {
    _submitSubscription?.close();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitStateChanged(
    AsyncValue<String?>? previous,
    AsyncValue<String?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
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

        await ref.read(authSessionProvider).markPasswordCreated();

        if (!mounted) {
          return;
        }

        context.showAppSnack(message, type: AppSnackType.success);
        ref.read(setupPasswordControllerProvider.notifier).reset();
        context.go(AppRoutePaths.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      setupPasswordControllerProvider.select((state) => state.isLoading),
    );

    return AppOverlayScaffold(
      title: context.l10n.authSetupPasswordTitle,
      bottom: AppButton(
        isLoading: isSubmitting,
        label: context.l10n.authCreatePasswordAction,
        onPressed: isSubmitting ? null : _submit,
      ),
      child: SetupPasswordContent(
        newPasswordController: _newPasswordController,
        confirmPasswordController: _confirmPasswordController,
        isNewPasswordObscured: _isNewPasswordObscured,
        isConfirmPasswordObscured: _isConfirmPasswordObscured,
        onToggleNewPasswordVisibility: () {
          setState(() {
            _isNewPasswordObscured = !_isNewPasswordObscured;
          });
        },
        onToggleConfirmPasswordVisibility: () {
          setState(() {
            _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
          });
        },
      ),
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
        type: AppSnackType.warning,
      );
      return;
    }

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(newPassword: newPassword);
  }
}
