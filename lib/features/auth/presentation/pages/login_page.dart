import 'package:bawabat_al_saeq/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/listeners/login_state_listener.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/layout/login_background.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/layout/login_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _phoneTextController;
  late final TextEditingController _passwordTextController;

  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _phoneTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );

    return LoginStateListener(
      child: Scaffold(
        body: LoginBackground(
          child: SafeArea(
            child: LoginScreenBody(
              formKey: _formKey,
              phoneController: _phoneTextController,
              passwordController: _passwordTextController,
              obscurePassword: _isPasswordObscured,
              onTogglePasswordVisibility: _togglePasswordVisibility,
              isLoading: isLoading,
              onSubmit: isLoading ? null : _submitSignIn,
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  Future<void> _submitSignIn() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          phone: _phoneTextController.text,
          password: _passwordTextController.text,
        );
  }
}
