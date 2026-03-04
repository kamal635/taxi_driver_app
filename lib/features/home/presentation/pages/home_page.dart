import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/current_request_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ProviderSubscription<Object?>? _error;
  ProviderSubscription<Object?>? _declineError;

  @override
  void initState() {
    super.initState();

    _error = ref.listenManual(
      accepteOfferControllerProvider.select((s) => s.error),
      (previous, next) {
        if (next == null) return;
        if (identical(previous, next)) return;

        final msg = failureToUserMessage(
          next.toString(),
          l10n: context.l10n,
        );
        context.showAppSnack(msg, type: AppSnackType.error);
      },
    );

    _declineError = ref.listenManual(
      declineOfferControllerProvider.select((s) => s.error),
      (previous, next) {
        if (next == null) return;
        if (identical(previous, next)) return;

        final msg = failureToUserMessage(
          next.toString(),
          l10n: context.l10n,
        );
        context.showAppSnack(msg, type: AppSnackType.error);
      },
    );
  }

  @override
  void dispose() {
    _error?.close();
    _declineError?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          AppSpacing.h16,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: _buildRequestArea(l10n),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestArea(AppLocalizations l10n) {
    final newOfferState = ref.watch(newOfferControllerProvider);
    final accepteOfferAsync = ref.watch(accepteOfferControllerProvider);
    final declineAsync = ref.watch(declineOfferControllerProvider);

    final newOffer = newOfferState.currentOffer;
    final accepted = accepteOfferAsync.value?.offerAcceptedEntity;

    final endsAt = accepteOfferAsync.value?.doneEndsAt;

    // 1) accepted
    if (accepted != null) {
      final phoneNumber = '\u200E+963 ${accepted.customerPhone}\u200E';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentRequestCard.accepted(
            isNotes: accepted.notes?.isNotEmpty ?? false,
            badgeTitle: accepted.type,
            phoneNumber: phoneNumber,
            priceText: '${accepted.price} SYP',
            pickup: accepted.pickup,
            endsAt: endsAt,
            dropoff: accepted.dropoff ?? l10n.unknown,
            primaryActionLabel: l10n.actionDone,
            countdownPrefix: l10n.homeAvailableIn,
            onPrimaryAction: () async {
              await ref.read(accepteOfferControllerProvider.notifier).clear();
              ref.read(newOfferControllerProvider.notifier).clearCurrent();
            },
          ),
          AppSpacing.h16,
        ],
      );
    }

    // 2) offer → empty
    if (newOffer == null) {
      return Center(
        child: HomeEmptyState(
          icon: Icons.search_rounded,
          title: l10n.homeEmptyTitle,
          subtitle: l10n.homeEmptySubtitle,
        ),
      );
    }

    // 3) otherwise → show offer card
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (newOfferState.isLoading)
          const CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primary,
          ),
        if (!newOfferState.isLoading)
          CurrentRequestCard.offer(
            isLoading: accepteOfferAsync.isLoading || declineAsync.isLoading,
            badgeTitle: newOffer.type,
            priceText: '${newOffer.price} SYP',
            pickup: newOffer.pickup,
            dropoff: newOffer.dropoff ?? l10n.unknown,
            acceptLabel: l10n.actionAccept,
            rejectLabel: l10n.actionReject,
            onAccept: accepteOfferAsync.isLoading
                ? null
                : () async {
                    // Accept the offer (HTTP).
                    await ref
                        .read(accepteOfferControllerProvider.notifier)
                        .accepte(offeroId: newOffer.offerId);

                    // Read accepted result (null if failed).
                    final accepted = ref
                        .read(accepteOfferControllerProvider)
                        .value
                        ?.offerAcceptedEntity;

                    // Clear incoming offer only if accept succeeded.
                    if (accepted != null) {
                      ref
                          .read(newOfferControllerProvider.notifier)
                          .clearCurrent();
                    }
                  },
            onReject: (accepteOfferAsync.isLoading || declineAsync.isLoading)
                ? null
                : () async {
                    await ref
                        .read(declineOfferControllerProvider.notifier)
                        .decline(offeroId: newOffer.offerId);

                    final declineState = ref.read(
                      declineOfferControllerProvider,
                    );

                    // Clear incoming offer only if decline succeeded.
                    if (!declineState.hasError) {
                      ref
                          .read(newOfferControllerProvider.notifier)
                          .clearCurrent();
                    }
                  },
          ),
        AppSpacing.h16,
      ],
    );
  }
}
