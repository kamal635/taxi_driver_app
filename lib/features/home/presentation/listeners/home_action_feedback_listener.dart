import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/complete_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeActionFeedbackListener extends ConsumerStatefulWidget {
  const HomeActionFeedbackListener({super.key});

  @override
  ConsumerState<HomeActionFeedbackListener> createState() =>
      _HomeActionFeedbackListenerState();
}

class _HomeActionFeedbackListenerState
    extends ConsumerState<HomeActionFeedbackListener> {
  ProviderSubscription<String?>? _newOfferSubscription;
  ProviderSubscription<Object?>? _acceptErrorSubscription;
  ProviderSubscription<Object?>? _declineErrorSubscription;
  ProviderSubscription<Object?>? _completeErrorSubscription;

  @override
  void initState() {
    super.initState();

    _newOfferSubscription = ref.listenManual<String?>(
      newOfferControllerProvider.select(
        (state) => state.asData?.value.errorMessage,
      ),
      (previous, next) {
        if (next == null || next.isEmpty || previous == next) {
          return;
        }

        final message = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );

    _acceptErrorSubscription = ref.listenManual<Object?>(
      acceptOfferControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null || identical(previous, next)) {
          return;
        }

        final message = failureToUserMessage(
          next.toString(),
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );

    _declineErrorSubscription = ref.listenManual<Object?>(
      declineOfferControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null || identical(previous, next)) {
          return;
        }

        final message = failureToUserMessage(
          next.toString(),
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );

    _completeErrorSubscription = ref.listenManual<Object?>(
      completeOfferControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null || identical(previous, next)) {
          return;
        }

        final message = failureToUserMessage(
          next.toString(),
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );
  }

  @override
  void dispose() {
    _newOfferSubscription?.close();
    _acceptErrorSubscription?.close();
    _declineErrorSubscription?.close();
    _completeErrorSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
