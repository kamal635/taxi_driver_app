import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/profile/presentation/controllers/sign_out_controller.dart';

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
        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (didSignOut) async {
        if (!didSignOut || (previous?.value ?? false)) {
          return;
        }

        if (mounted) {
          context.go(AppRoutePaths.login);
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
