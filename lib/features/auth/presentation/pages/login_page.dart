import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:taxi_driver_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_footer.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_form.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    _listenToAuthState();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [AppColors.bgWarm, AppColors.bgBase],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                const LoginHeader(),
                LoginForm(
                  phoneController: _phoneTextController,
                  passwordController: _passwordTextController,
                  obscurePassword: _isPasswordObscured,
                  onTogglePasswordVisibility: _togglePasswordVisibility,
                  isLoading: isLoading,
                  onSubmit: isLoading ? null : _submitSignIn,
                ),
                const LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Listens to auth state changes and reacts with UI side effects.
  void _listenToAuthState() {
    ref.listen(authControllerProvider, (previous, next) async {
      await next.whenOrNull(
        error: (error, _) {
          final message = failureToUserMessage(
            error,
            l10n: context.l10n,
            context: FailureContext.authLogin,
          );

          context.showAppSnack(message, type: AppSnackType.error);
        },
        data: (result) async {
          if (result == null) {
            return;
          }

          switch (result) {
            case AuthSignedIn(:final authSession):
              await _saveSignedInSession(authSession);
              return;

            case AuthSetupRequired(:final authSession):
              await _saveSetupRequiredSession(authSession);
              return;
          }
        },
      );
    });
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordObscured = !_isPasswordObscured);
  }

  /// Submits the current form values to the auth controller.
  Future<void> _submitSignIn() async {
    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          phone: _phoneTextController.text.trim(),
          password: _passwordTextController.text,
          // fcmToken: Add later when push notifications are wired.
        );
  }

  Future<void> _saveSignedInSession(AuthSessionEntity session) async {
    final authSessionStore = ref.read(authSessionProvider);

    await authSessionStore.saveAfterLogin(
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

    context.go(AppRoutes.home);
  }

  Future<void> _saveSetupRequiredSession(AuthSessionEntity session) async {
    final authSessionStore = ref.read(authSessionProvider);

    await authSessionStore.saveAfterLogin(
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

    context.go(
      AppRoutes.setupPassword,
      extra: session,
    );
  }
}
