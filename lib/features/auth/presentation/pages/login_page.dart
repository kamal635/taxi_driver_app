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
  // Controllers for text inputs
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  // UI state: password visibility
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers once
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authSession = ref.read(authSessionProvider);

    ref.listen(authControllerProvider, (prev, next) async {
      await next.whenOrNull(
        error: (err, _) {
          final msg = failureToUserMessage(
            err,
            l10n: context.l10n,
            context: FailureContext.authLogin,
          );
          context.showAppSnack(msg, type: AppSnackType.error);
        },
        data: (result) async {
          if (result == null) return;

          switch (result) {
            case AuthSignedIn(:final authSessionEntity):
              await authSession.saveAfterLogin(
                driverName: authSessionEntity.driverName,
                driverPhone: authSessionEntity.driverPhone,
                driverId: authSessionEntity.driverId,
                token: authSessionEntity.accessToken,
                refreshToken: authSessionEntity.refreshToken,
                mustChangePassword: false,
              );
              if (context.mounted) context.go(AppRoutes.home);
              return;

            case AuthSetupRequired(:final authSessionEntity):
              await authSession.saveAfterLogin(
                driverName: authSessionEntity.driverName,
                driverPhone: authSessionEntity.driverPhone,
                driverId: authSessionEntity.driverId,
                token: authSessionEntity.accessToken,
                refreshToken: authSessionEntity.refreshToken,
                mustChangePassword: true,
              );
              if (context.mounted) {
                context.go(
                  AppRoutes.setupPassword,
                  extra: authSessionEntity,
                );
              }
              return;
          }
        },
      );
    });

    // Current auth state
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background gradient
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

                // The main form
                LoginForm(
                  phoneController: _phoneController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePasswordVisibility: () {
                    // Toggle visibility
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  isLoading: isLoading,

                  // Submit handler
                  onSubmit: isLoading
                      ? null
                      : () async {
                          TextInput.finishAutofillContext();
                          FocusScope.of(context).unfocus();

                          await ref
                              .read(authControllerProvider.notifier)
                              .signIn(
                                phone: _phoneController.text.trim(),
                                password: _passwordController.text,
                                // fcmToken: ... later
                              );
                        },
                ),

                const LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
