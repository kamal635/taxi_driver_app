import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

enum HomeRequestUiState { empty, offer, current }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  HomeRequestUiState _requestState = HomeRequestUiState.offer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          AppSpacing.h16,

          /// Requests
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
    switch (_requestState) {
      case HomeRequestUiState.offer:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentRequestCard.offer(
              title: l10n.homeRequestNewTitle,
              fareText: '${l10n.homeFarePrefix} 15,000 SYP',
              pickup: '${l10n.homePickupPrefix} Mazzeh',
              dropoff: '${l10n.homeDropoffPrefix} Umayyad Square',
              acceptLabel: l10n.actionAccept,
              rejectLabel: l10n.actionReject,
              onAccept: () =>
                  setState(() => _requestState = HomeRequestUiState.current),
              onReject: () =>
                  setState(() => _requestState = HomeRequestUiState.empty),
            ),
            AppSpacing.h16,
          ],
        );

      case HomeRequestUiState.current:
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
