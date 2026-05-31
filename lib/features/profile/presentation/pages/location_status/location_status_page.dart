import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/controllers/location_status_controller.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_content.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_error_card.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_loading_card.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the current location services and permissions state for the driver.
class LocationStatusPage extends ConsumerWidget {
  const LocationStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final statusState = ref.watch(locationStatusControllerProvider);
    final controller = ref.read(locationStatusControllerProvider.notifier);
    final isBusy = statusState.isLoading;

    return AppOverlayScaffold(
      title: l10n.profileLocationStatusTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileLocationStatusPageSubtitle,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.h16,
          statusState.when(
            loading: () => const LocationStatusLoadingCard(),
            error: (_, _) => LocationStatusErrorCard(
              isBusy: isBusy,
              onRefreshPressed: () => unawaited(controller.refresh()),
            ),
            data: (status) => LocationStatusContent(
              status: status,
              isBusy: isBusy,
              onRefreshPressed: () => unawaited(controller.refresh()),
              onRequestPermissionPressed: () => unawaited(
                controller.requestPermission(),
              ),
              onOpenAppSettingsPressed: () => unawaited(
                controller.openAppSettings(),
              ),
              onOpenLocationSettingsPressed: () => unawaited(
                controller.openLocationSettings(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
