import 'dart:async' show unawaited;
import 'dart:io';

import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/avatar/avatar_controller.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/core/widgets/pill_switch.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/availability_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTopBar extends ConsumerWidget {
  const AppTopBar({
    required this.title,
    required this.onAvatarPressed,
    super.key,
  });

  final String title;
  final VoidCallback onAvatarPressed;

  Future<void> _handleAvailabilityChanged(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final restoredCurrentOffer = ref.read(restoredCurrentOfferProvider);
    final acceptedOffer = ref
        .read(acceptOfferControllerProvider)
        .value
        ?.acceptedOffer;

    final hasActiveTrip = restoredCurrentOffer != null || acceptedOffer != null;

    if (value && hasActiveTrip) {
      context.showAppSnack(
        context.l10n.availabilityActiveTripOnlineBlocked,
        type: AppSnackType.error,
      );
      return;
    }

    await ref
        .read(availabilityProvider.notifier)
        .requestSetOnline(value: value);

    if (value) {
      return;
    }

    ref
            .read(
              hasRequestedRestoreForCurrentOnlineSessionProvider.notifier,
            )
            .state =
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final (:isOnline, :isBusy) = ref.watch(
      availabilityProvider.select(
        (state) => (
          isOnline: state.isOnline,
          isBusy: state.isBusy,
        ),
      ),
    );

    final avatarAsync = ref.watch(avatarControllerProvider);
    final avatarPath = avatarAsync.value;

    final displayName = ref.watch(
      authSessionSnapshotProvider.select(
        (snapshot) => snapshot.driverName?.trim() ?? '',
      ),
    );
    final initial = displayName.isNotEmpty ? displayName[0] : '—';
    final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;

    return Row(
      children: [
        AppSpacing.w10,
        PillSwitch(
          value: isOnline,
          onChanged: isBusy
              ? null
              : (value) => unawaited(
                  _handleAvailabilityChanged(context, ref, value),
                ),
          offLabel: l10n.offline,
          onLabel: l10n.online,
          uppercase: false,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleSm,
          ),
        ),
        AppSpacing.w12,
        GestureDetector(
          onTap: avatarAsync.isLoading ? null : onAvatarPressed,
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              color: AppColors.white,
            ),
            alignment: Alignment.center,
            child: hasAvatar
                ? ClipOval(
                    child: Image.file(
                      File(avatarPath),
                      width: 38.r,
                      height: 38.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Text(initial, style: AppTypography.labelMd);
                      },
                    ),
                  )
                : Text(initial, style: AppTypography.labelMd),
          ),
        ),
      ],
    );
  }
}
