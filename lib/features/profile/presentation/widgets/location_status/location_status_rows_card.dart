import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/location_status/location_status_row.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationStatusRowsCard extends StatelessWidget {
  const LocationStatusRowsCard({required this.status, super.key});

  final LocationStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCardSurface(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        children: [
          LocationStatusRow(
            title: l10n.locationStatusServiceTitle,
            subtitle: status.isServiceEnabled
                ? l10n.locationStatusServiceEnabled
                : l10n.locationStatusServiceDisabled,
            icon: status.isServiceEnabled
                ? Icons.location_on_rounded
                : Icons.location_disabled_rounded,
            state: status.isServiceEnabled
                ? LocationStatusRowState.ready
                : LocationStatusRowState.warning,
          ),
          LocationStatusRow(
            title: l10n.locationStatusPermissionTitle,
            subtitle: _permissionSubtitle(context, status.permissionStatus),
            icon: status.hasForegroundPermission
                ? Icons.my_location_rounded
                : Icons.location_off_rounded,
            state: status.hasForegroundPermission
                ? LocationStatusRowState.ready
                : LocationStatusRowState.warning,
          ),
          LocationStatusRow(
            title: l10n.locationStatusBackgroundTitle,
            subtitle: status.hasBackgroundPermission
                ? l10n.locationStatusBackgroundGranted
                : l10n.locationStatusBackgroundMissing,
            icon: status.hasBackgroundPermission
                ? Icons.route_rounded
                : Icons.route_outlined,
            state: status.hasBackgroundPermission
                ? LocationStatusRowState.ready
                : LocationStatusRowState.info,
          ),
        ],
      ),
    );
  }

  String _permissionSubtitle(
    BuildContext context,
    AppLocationPermissionStatus permissionStatus,
  ) {
    final l10n = context.l10n;

    return switch (permissionStatus) {
      AppLocationPermissionStatus.denied => l10n.locationStatusPermissionDenied,
      AppLocationPermissionStatus.deniedForever =>
        l10n.locationStatusPermissionDeniedForever,
      AppLocationPermissionStatus.whileInUse =>
        l10n.locationStatusPermissionWhileInUse,
      AppLocationPermissionStatus.always => l10n.locationStatusPermissionAlways,
      AppLocationPermissionStatus.unableToDetermine =>
        l10n.locationStatusPermissionUnable,
    };
  }
}
