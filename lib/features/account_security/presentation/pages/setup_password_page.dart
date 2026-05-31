import 'dart:async';

import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/listeners/setup_password_state_listener.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/validators/setup_password_form_validator.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/widgets/layout/setup_password_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

    return SetupPasswordStateListener(
      child: SetupPasswordScreenBody(
        formKey: _formKey,
        newPasswordController: _newPasswordController,
        confirmPasswordController: _confirmPasswordController,
        newPasswordFocusNode: _newPasswordFocusNode,
        confirmPasswordFocusNode: _confirmPasswordFocusNode,
        isSubmitting: isSubmitting,
        isNewPasswordObscured: _isNewPasswordObscured,
        isConfirmPasswordObscured: _isConfirmPasswordObscured,
        onSubmit: isSubmitting ? null : _submit,
        onNewPasswordSubmitted: (_) {
          _confirmPasswordFocusNode.requestFocus();
        },
        onConfirmPasswordSubmitted: (_) {
          if (!isSubmitting) {
            unawaited(_submit());
          }
        },
        onValidatePassword: (value) {
          return SetupPasswordFormValidator.validatePassword(context, value);
        },
        onValidateConfirmPassword: (value) {
          return SetupPasswordFormValidator.validateConfirmation(
            context,
            value: value,
            password: _newPasswordController.text,
          );
        },
        onToggleNewPasswordVisibility: _toggleNewPasswordVisibility,
        onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
      ),
    );
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordObscured = !_isNewPasswordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    });
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: _newPasswordController.text.trim(),
        );
  }
}
