import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_orders_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

enum HomeRequestUiState { empty, newOffer, accepted }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  HomeRequestUiState _requestState = HomeRequestUiState.newOffer;

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
    final state = ref.watch(newOrdersControllerProvider);
    final currentOrder = state.currentOrder;

    // If we're "waiting for a new offer" but none exists, show the empty state.
    if (_requestState == HomeRequestUiState.newOffer && currentOrder == null) {
      return Center(
        child: HomeEmptyState(
          icon: Icons.search_rounded,
          title: l10n.homeEmptyTitle,
          subtitle: l10n.homeEmptySubtitle,
        ),
      );
    }

    switch (_requestState) {
      case HomeRequestUiState.newOffer:
        // currentOrder is not null here due to the guard above.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isLoading)
              const CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.taxiYellow,
              ),
            if (!state.isLoading)
              CurrentRequestCard.offer(
                title: currentOrder!.type,
                priceText: currentOrder.price,
                pickup: currentOrder.pickup,
                // Avoid `!` crash. Use a safe fallback.
                dropoff: currentOrder.dropoff ?? l10n.unknown,
                acceptLabel: l10n.actionAccept,
                rejectLabel: l10n.actionReject,
                onAccept: () => setState(
                  () => _requestState = HomeRequestUiState.accepted,
                ),
                onReject: () => setState(
                  () => _requestState = HomeRequestUiState.empty,
                ),
              ),
            AppSpacing.h16,
          ],
        );

      case HomeRequestUiState.accepted:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentRequestCard.current(
              title: l10n.homeRequestCurrentTitle,
              phoneNumber: '+963 996 500 748',
              fareText: '${l10n.homeFarePrefix} 15,000 SYP',
              pickup: '${l10n.homePickupPrefix} Mazzeh',
              dropoff: '${l10n.homeDropoffPrefix} Umayyad Square',
              primaryActionLabel: l10n.actionDone,
              countdownPrefix: l10n.homeAvailableIn,
              onPrimaryAction: () =>
                  setState(() => _requestState = HomeRequestUiState.empty),
            ),
            AppSpacing.h16,
          ],
        );

      case HomeRequestUiState.empty:
        return Center(
          child: HomeEmptyState(
            icon: Icons.search_rounded,
            title: l10n.homeEmptyTitle,
            subtitle: l10n.homeEmptySubtitle,
          ),
        );
    }
  }
}
