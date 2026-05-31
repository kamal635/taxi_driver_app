import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_primary_action.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_rows_card.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_summary_card.dart';
import 'package:flutter/material.dart';

class LocationStatusContent extends StatelessWidget {
  const LocationStatusContent({
    required this.status,
    required this.isBusy,
    required this.onRefreshPressed,
    required this.onRequestPermissionPressed,
    required this.onOpenAppSettingsPressed,
    required this.onOpenLocationSettingsPressed,
    super.key,
  });

  final LocationStatus status;
  final bool isBusy;
  final VoidCallback onRefreshPressed;
  final VoidCallback onRequestPermissionPressed;
  final VoidCallback onOpenAppSettingsPressed;
  final VoidCallback onOpenLocationSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationStatusRowsCard(status: status),
        AppSpacing.h16,
        LocationStatusSummaryCard(isReady: status.isReady),
        AppSpacing.h18,
        LocationStatusPrimaryAction(
          status: status,
          isBusy: isBusy,
          onRequestPermissionPressed: onRequestPermissionPressed,
          onOpenAppSettingsPressed: onOpenAppSettingsPressed,
          onOpenLocationSettingsPressed: onOpenLocationSettingsPressed,
          onRefreshPressed: onRefreshPressed,
        ),
        AppSpacing.h10,
        TextButton.icon(
          onPressed: isBusy ? null : onRefreshPressed,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.locationStatusRefreshAction),
        ),
      ],
    );
  }
}
