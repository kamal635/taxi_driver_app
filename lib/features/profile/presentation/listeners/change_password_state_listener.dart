import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Listens for password-change results when the listener is mounted separately.
///
/// Most password-change flows can listen inside the page itself. This widget is
/// kept for route/shell compositions that prefer side-effect listeners as
/// separate mounted widgets.
class ChangePasswordStateListener extends ConsumerStatefulWidget {
  const ChangePasswordStateListener({super.key});

  @override
  ConsumerState<ChangePasswordStateListener> createState() =>
      _ChangePasswordStateListenerState();
}

class _ChangePasswordStateListenerState
    extends ConsumerState<ChangePasswordStateListener> {
  ProviderSubscription<AsyncValue<SetupPasswordResult?>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<AsyncValue<SetupPasswordResult?>>(
      setupPasswordControllerProvider,
      _handleSubmitStateChanged,
    );
  }

  Future<void> _handleSubmitStateChanged(
    AsyncValue<SetupPasswordResult?>? previous,
    AsyncValue<SetupPasswordResult?> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!mounted) {
          return;
        }

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (result) async {
        if (result == null ||
            result.submissionId == previous?.asData?.value?.submissionId ||
            !mounted) {
          return;
        }

        context.showAppSnack(
          result.message ?? context.l10n.profilePasswordUpdatedSuccess,
          type: AppSnackType.success,
        );
        ref.read(setupPasswordControllerProvider.notifier).reset();
        context.pop();
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
