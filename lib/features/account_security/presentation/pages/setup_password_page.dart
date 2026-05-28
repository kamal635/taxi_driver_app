import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_result.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/widgets/setup_password_content.dart';
import 'package:bawabat_al_saeq/shared/presentation/validation/password_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetupPasswordPage extends ConsumerStatefulWidget {
  const SetupPasswordPage({super.key});

  @override
  ConsumerState<SetupPasswordPage> createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends ConsumerState<SetupPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _newPasswordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;
  ProviderSubscription<AsyncValue<SetupPasswordResult?>>? _submitSubscription;

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

  @override
  void dispose() {
    _submitSubscription?.close();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitStateChanged(
    AsyncValue<SetupPasswordResult?>? previous,
    AsyncValue<SetupPasswordResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!mounted) return;

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );

        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (result) async {
        if (result == null) {
          return;
        }

        final previousResult = previous?.asData?.value;
        if (previousResult?.submissionId == result.submissionId) {
          return;
        }

        await ref.read(authSessionProvider).markPasswordCreated();

        if (!mounted) {
          return;
        }

        final message = result.message;
        if (message != null && message.isNotEmpty) {
          context.showAppSnack(message, type: AppSnackType.success);
        }

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
      child: Form(
        key: _formKey,
        child: SetupPasswordContent(
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
          newPasswordFocusNode: _newPasswordFocusNode,
          confirmPasswordFocusNode: _confirmPasswordFocusNode,
          isSubmitting: isSubmitting,
          isNewPasswordObscured: _isNewPasswordObscured,
          isConfirmPasswordObscured: _isConfirmPasswordObscured,
          onNewPasswordSubmitted: (_) {
            _confirmPasswordFocusNode.requestFocus();
          },
          onConfirmPasswordSubmitted: (_) async {
            if (!isSubmitting) {
              await _submit();
            }
          },
          onValidatePassword: _validatePassword,
          onValidateConfirmPassword: _validateConfirmPassword,
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
      ),
    );
  }

  String? _validatePassword(String? value) {
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
      mismatchMessage: context.l10n.errorValidation,
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: _newPasswordController.text.trim(),
        );
  }
}
