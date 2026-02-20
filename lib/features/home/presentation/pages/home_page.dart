import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/availability_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

final isOnlineProvider = StateProvider<bool>((ref) => true);

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

    // ✅ اقرأ الحالة من Riverpod
    final isOnline = ref.watch(isOnlineProvider);

    final availability = isOnline
        ? (
            title: l10n.homeAvailabilityOnTitle,
            subtitle: l10n.homeAvailabilityOnSubtitle,
          )
        : (
            title: l10n.homeAvailabilityOffTitle,
            subtitle: l10n.homeAvailabilityOffSubtitle,
          );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          /// Availability
          AvailabilityCard(
            // إذا AvailabilityCard عندك بتطلب isOnline/textPill ضيفن:
            // isOnline: isOnline,
            title: availability.title,
            subtitle: availability.subtitle,

            // textPill: isOnline ? l10n.online : l10n.offline,
            onChanged: (v) async {
              // Confirm only when turning OFF
              if (isOnline && !v) {
                final ok = await showAppConfirmDialog(
                  context: context,
                  title: l10n.availabilityTurnOffTitle,
                  message: l10n.availabilityTurnOffMessage,
                  confirmLabel: l10n.actionConfirm,
                  cancelLabel: l10n.actionCancel,
                  icon: Icons.power_settings_new_rounded,
                  barrierDismissible: true,
                  backgroundIconColor: AppColors.errorBg,
                  iconColor: AppColors.error,
                );

                if (!ok) return;
              }

              // ✅ حدّث الـ provider (بدل setState على isOnline)
              ref.read(isOnlineProvider.notifier).state = v;
            },
          ),

          AppSpacing.h8,

          /// Requests
          Expanded(
            child: SingleChildScrollView(
              child: _buildRequestArea(l10n),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeEmptyState(
              icon: Icons.search_rounded,
              title: l10n.homeEmptyTitle,
              subtitle: l10n.homeEmptySubtitle,
            ),
            AppSpacing.h16,
          ],
        );
    }
  }
}
