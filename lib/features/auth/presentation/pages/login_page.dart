import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/login_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _phoneTextController;
  late final TextEditingController _passwordTextController;

  ProviderSubscription<AsyncValue<AuthSignInResult?>>? _authSubscription;

  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();

    _phoneTextController = TextEditingController();
    _passwordTextController = TextEditingController();

    _authSubscription = ref.listenManual<AsyncValue<AuthSignInResult?>>(
      authControllerProvider,
      _handleAuthStateChanged,
    );
  }

  @override
  void dispose() {
    _authSubscription?.close();
    _phoneTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> _handleAuthStateChanged(
    AsyncValue<AuthSignInResult?>? previous,
    AsyncValue<AuthSignInResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!mounted) {
          return;
        }

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
          context: FailureContext.authLogin,
        );

        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (result) async {
        if (result == null || result == previous?.value) {
          return;
        }

        switch (result) {
          case AuthSignedIn(:final authSession):
            await _saveSignedInSession(authSession);
          case AuthSetupRequired(:final authSession):
            await _saveSetupRequiredSession(authSession);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [AppColors.bgWarm, AppColors.bgBase],
          ),
        ),
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

  Future<void> _saveSignedInSession(AuthSessionEntity session) async {
    await ref
        .read(authSessionProvider)
        .saveAfterLogin(
          driverName: session.driverName,
          driverPhone: session.driverPhone,
          driverId: session.driverId,
          token: session.accessToken,
          refreshToken: session.refreshToken,
          mustChangePassword: false,
        );

    if (!mounted) {
      return;
    }

    context.go(AppRoutePaths.home);
  }

  Future<void> _saveSetupRequiredSession(AuthSessionEntity session) async {
    await ref
        .read(authSessionProvider)
        .saveAfterLogin(
          driverName: session.driverName,
          driverPhone: session.driverPhone,
          driverId: session.driverId,
          token: session.accessToken,
          refreshToken: session.refreshToken,
          mustChangePassword: true,
        );

    if (!mounted) {
      return;
    }

    context.go(AppRoutePaths.setupPassword, extra: session);
  }
}
