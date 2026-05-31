import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Listens to login state changes and owns login side effects.
class LoginStateListener extends ConsumerWidget {
  const LoginStateListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AuthSignInResult?>>(
      authControllerProvider,
      (previous, next) {
        unawaited(_handleAuthStateChanged(context, ref, previous, next));
      },
    );

    return child;
  }

  Future<void> _handleAuthStateChanged(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<AuthSignInResult?>? previous,
    AsyncValue<AuthSignInResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!context.mounted) {
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
        final previousResult = previous?.whenOrNull(data: (value) => value);

        if (result == null || result == previousResult) {
          return;
        }

        switch (result) {
          case AuthSignedIn(:final authSession):
            await _saveSignedInSession(context, ref, authSession);
          case AuthSetupRequired(:final authSession):
            await _saveSetupRequiredSession(context, ref, authSession);
        }
      },
    );
  }

  Future<void> _saveSignedInSession(
    BuildContext context,
    WidgetRef ref,
    AuthSessionEntity session,
  ) async {
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

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutePaths.home);
  }

  Future<void> _saveSetupRequiredSession(
    BuildContext context,
    WidgetRef ref,
    AuthSessionEntity session,
  ) async {
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

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutePaths.setupPassword, extra: session);
  }
}
