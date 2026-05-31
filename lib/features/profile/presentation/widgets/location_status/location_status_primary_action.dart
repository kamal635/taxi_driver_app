import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class LocationStatusPrimaryAction extends StatelessWidget {
  const LocationStatusPrimaryAction({
    required this.status,
    required this.isBusy,
    required this.onRequestPermissionPressed,
    required this.onOpenAppSettingsPressed,
    required this.onOpenLocationSettingsPressed,
    required this.onRefreshPressed,
    super.key,
  });

  final LocationStatus status;
  final bool isBusy;
  final VoidCallback onRequestPermissionPressed;
  final VoidCallback onOpenAppSettingsPressed;
  final VoidCallback onOpenLocationSettingsPressed;
  final VoidCallback onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!status.isServiceEnabled) {
      return AppButton(
        label: l10n.locationStatusOpenLocationSettingsAction,
        isLoading: isBusy,
        onPressed: isBusy ? null : onOpenLocationSettingsPressed,
      );
    }

    if (!status.hasForegroundPermission) {
      final mustOpenSettings =
          status.permissionStatus == AppLocationPermissionStatus.deniedForever;

      return AppButton(
        label: mustOpenSettings
            ? l10n.locationStatusOpenAppSettingsAction
            : l10n.locationStatusRequestPermissionAction,
        isLoading: isBusy,
        onPressed: isBusy
            ? null
            : mustOpenSettings
            ? onOpenAppSettingsPressed
            : onRequestPermissionPressed,
      );
    }

    return AppButton(
      label: l10n.locationStatusRefreshAction,
      isLoading: isBusy,
      onPressed: isBusy ? null : onRefreshPressed,
    );
  }
}
