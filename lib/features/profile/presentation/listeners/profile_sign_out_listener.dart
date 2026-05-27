import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileSignOutListener extends ConsumerStatefulWidget {
  const ProfileSignOutListener({super.key});

  @override
  ConsumerState<ProfileSignOutListener> createState() =>
      _ProfileSignOutListenerState();
}

class _ProfileSignOutListenerState
    extends ConsumerState<ProfileSignOutListener> {
  ProviderSubscription<AsyncValue<bool>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<AsyncValue<bool>>(
      signOutControllerProvider,
      _handleStateChanged,
    );
  }

  Future<void> _handleStateChanged(
    AsyncValue<bool>? previous,
    AsyncValue<bool> next,
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
        ref.read(signOutControllerProvider.notifier).reset();
      },
      data: (didSignOut) async {
        if (!didSignOut || (previous?.asData?.value ?? false) || !mounted) {
          return;
        }

        ref.read(signOutControllerProvider.notifier).reset();
        context.go(AppRoutePaths.login);
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
