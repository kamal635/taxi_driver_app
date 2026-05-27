import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripsErrorListener extends ConsumerStatefulWidget {
  const TripsErrorListener({super.key});

  @override
  ConsumerState<TripsErrorListener> createState() => _TripsErrorListenerState();
}

class _TripsErrorListenerState extends ConsumerState<TripsErrorListener> {
  ProviderSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ref.listenManual<Object?>(
      completedOffersControllerProvider.select((state) => state.error),
      (previous, next) {
        if (!mounted || next == null || identical(previous, next)) {
          return;
        }

        final message = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
