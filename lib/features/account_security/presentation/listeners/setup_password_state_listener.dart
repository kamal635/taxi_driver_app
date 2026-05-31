import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Owns setup-password side effects such as snackbars, session updates,
/// and navigation after a successful password creation.
class SetupPasswordStateListener extends ConsumerWidget {
  const SetupPasswordStateListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SetupPasswordResult?>>(
      setupPasswordControllerProvider,
      (previous, next) {
        unawaited(_handleSubmitStateChanged(context, ref, previous, next));
      },
    );

    return child;
  }

  Future<void> _handleSubmitStateChanged(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<SetupPasswordResult?>? previous,
    AsyncValue<SetupPasswordResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!context.mounted) {
          return;
        }

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );

        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (result) async {
        if (result == null || _isSameSuccess(previous, result)) {
          return;
        }

        await ref.read(authSessionProvider).markPasswordCreated();

        if (!context.mounted) {
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

  bool _isSameSuccess(
    AsyncValue<SetupPasswordResult?>? previous,
    SetupPasswordResult result,
  ) {
    final previousResult = previous?.asData?.value;
    return previousResult?.submissionId == result.submissionId;
  }
}
