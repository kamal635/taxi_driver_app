import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordStateListener extends ConsumerStatefulWidget {
  const ChangePasswordStateListener({super.key});

  @override
  ConsumerState<ChangePasswordStateListener> createState() =>
      _ChangePasswordStateListenerState();
}

class _ChangePasswordStateListenerState
    extends ConsumerState<ChangePasswordStateListener> {
  ProviderSubscription<AsyncValue<String?>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<AsyncValue<String?>>(
      setupPasswordControllerProvider,
      _handleSubmitStateChanged,
    );
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
        if (message == null || message.isEmpty || message == previous?.value) {
          return;
        }

        context.showAppSnack(message, type: AppSnackType.success);
        ref.read(setupPasswordControllerProvider.notifier).reset();

        if (mounted) {
          context.pop();
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
