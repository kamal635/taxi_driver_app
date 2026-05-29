import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/location/location_providers.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the current location services and permissions state for the driver.
class LocationStatusPage extends ConsumerStatefulWidget {
  const LocationStatusPage({super.key});

  @override
  ConsumerState<LocationStatusPage> createState() => _LocationStatusPageState();
}

class _LocationStatusPageState extends ConsumerState<LocationStatusPage> {
  late Future<LocationStatus> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = _loadStatus();
  }

  Future<LocationStatus> _loadStatus() {
    return ref.read(locationServiceProvider).checkStatus();
  }

  void _refreshStatus() {
    setState(() {
      _statusFuture = _loadStatus();
    });
  }

  Future<void> _requestLocationPermission() async {
    await ref.read(locationServiceProvider).ensureReady();

    if (!mounted) {
      return;
    }

    _refreshStatus();
  }

  Future<void> _openAppSettings() async {
    await ref.read(locationServiceProvider).openAppSettings();

    if (!mounted) {
      return;
    }

    _refreshStatus();
  }

  Future<void> _openLocationSettings() async {
    await ref.read(locationServiceProvider).openLocationSettings();

    if (!mounted) {
      return;
    }

    _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppOverlayScaffold(
      title: l10n.profileLocationStatusTitle,
      child: FutureBuilder<LocationStatus>(
        future: _statusFuture,
        builder: (context, snapshot) {
          final status = snapshot.data;
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profileLocationStatusPageSubtitle,
                style: AppTypography.subtitleSm.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              AppSpacing.h16,
              if (isLoading)
                const _LocationStatusLoadingCard()
              else if (status != null)
                _LocationStatusContent(
                  status: status,
                  onRefreshPressed: _refreshStatus,
                  onRequestPermissionPressed: _requestLocationPermission,
                  onOpenAppSettingsPressed: _openAppSettings,
                  onOpenLocationSettingsPressed: _openLocationSettings,
                )
              else
                _LocationStatusErrorCard(onRefreshPressed: _refreshStatus),
            ],
          );
        },
      ),
    );
  }
}

class _LocationStatusContent extends StatelessWidget {
  const _LocationStatusContent({
    required this.status,
    required this.onRefreshPressed,
    required this.onRequestPermissionPressed,
    required this.onOpenAppSettingsPressed,
    required this.onOpenLocationSettingsPressed,
  });

  final LocationStatus status;
  final VoidCallback onRefreshPressed;
  final VoidCallback onRequestPermissionPressed;
  final VoidCallback onOpenAppSettingsPressed;
  final VoidCallback onOpenLocationSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isReadyForRequests =
        status.isServiceEnabled && status.hasForegroundPermission;

    return Column(
      children: [
        AppCardSurface(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Column(
            children: [
              _LocationStatusRow(
                title: l10n.locationStatusServiceTitle,
                subtitle: status.isServiceEnabled
                    ? l10n.locationStatusServiceEnabled
                    : l10n.locationStatusServiceDisabled,
                icon: status.isServiceEnabled
                    ? Icons.location_on_rounded
                    : Icons.location_disabled_rounded,
                state: status.isServiceEnabled
                    ? _LocationStatusRowState.ready
                    : _LocationStatusRowState.warning,
              ),
              _LocationStatusRow(
                title: l10n.locationStatusPermissionTitle,
                subtitle: _permissionSubtitle(context, status.permissionStatus),
                icon: status.hasForegroundPermission
                    ? Icons.my_location_rounded
                    : Icons.location_off_rounded,
                state: status.hasForegroundPermission
                    ? _LocationStatusRowState.ready
                    : _LocationStatusRowState.warning,
              ),
              _LocationStatusRow(
                title: l10n.locationStatusBackgroundTitle,
                subtitle: status.hasBackgroundPermission
                    ? l10n.locationStatusBackgroundGranted
                    : l10n.locationStatusBackgroundMissing,
                icon: status.hasBackgroundPermission
                    ? Icons.route_rounded
                    : Icons.route_outlined,
                state: status.hasBackgroundPermission
                    ? _LocationStatusRowState.ready
                    : _LocationStatusRowState.info,
              ),
            ],
          ),
        ),
        AppSpacing.h16,
        AppCardSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _LocationStatusSummaryIcon(isReady: isReadyForRequests),
                  AppSpacing.w12,
                  Expanded(
                    child: Text(
                      isReadyForRequests
                          ? l10n.locationStatusReadyTitle
                          : l10n.locationStatusNeedsAttentionTitle,
                      style: AppTypography.labelMd.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.h10,
              Text(
                l10n.locationStatusWhyMessage,
                style: AppTypography.subtitleSm.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.h18,
        _LocationPrimaryAction(
          status: status,
          onRequestPermissionPressed: onRequestPermissionPressed,
          onOpenAppSettingsPressed: onOpenAppSettingsPressed,
          onOpenLocationSettingsPressed: onOpenLocationSettingsPressed,
          onRefreshPressed: onRefreshPressed,
        ),
        AppSpacing.h10,
        TextButton.icon(
          onPressed: onRefreshPressed,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l10n.locationStatusRefreshAction),
        ),
      ],
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

class _LocationPrimaryAction extends StatelessWidget {
  const _LocationPrimaryAction({
    required this.status,
    required this.onRequestPermissionPressed,
    required this.onOpenAppSettingsPressed,
    required this.onOpenLocationSettingsPressed,
    required this.onRefreshPressed,
  });

  final LocationStatus status;
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
        onPressed: onOpenLocationSettingsPressed,
      );
    }

    if (!status.hasForegroundPermission) {
      final mustOpenSettings =
          status.permissionStatus == AppLocationPermissionStatus.deniedForever;

      return AppButton(
        label: mustOpenSettings
            ? l10n.locationStatusOpenAppSettingsAction
            : l10n.locationStatusRequestPermissionAction,
        onPressed: mustOpenSettings
            ? onOpenAppSettingsPressed
            : onRequestPermissionPressed,
      );
    }

    return AppButton(
      label: l10n.locationStatusRefreshAction,
      onPressed: onRefreshPressed,
    );
  }
}

class _LocationStatusRow extends StatelessWidget {
  const _LocationStatusRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.state,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final _LocationStatusRowState state;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (state) {
      _LocationStatusRowState.ready => context.colors.success,
      _LocationStatusRowState.info => context.colors.info,
      _LocationStatusRowState.warning => context.colors.error,
    };

    final backgroundColor = switch (state) {
      _LocationStatusRowState.ready => context.colors.successBg,
      _LocationStatusRowState.info => context.colors.infoBg,
      _LocationStatusRowState.warning => context.colors.errorBg,
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: context.colors.border),
            ),
            child: Icon(
              icon,
              size: 22.r,
              color: accentColor,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                AppSpacing.h6,
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subtitleSm.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            switch (state) {
              _LocationStatusRowState.ready => Icons.check_circle_rounded,
              _LocationStatusRowState.info => Icons.info_rounded,
              _LocationStatusRowState.warning => Icons.error_rounded,
            },
            size: 22.r,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}

class _LocationStatusSummaryIcon extends StatelessWidget {
  const _LocationStatusSummaryIcon({required this.isReady});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final color = isReady ? context.colors.success : context.colors.error;
    final backgroundColor = isReady
        ? context.colors.successBg
        : context.colors.errorBg;

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border),
      ),
      child: Icon(
        isReady ? Icons.verified_rounded : Icons.warning_rounded,
        color: color,
        size: 22.r,
      ),
    );
  }
}

class _LocationStatusLoadingCard extends StatelessWidget {
  const _LocationStatusLoadingCard();

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      child: Row(
        children: [
          SizedBox.square(
            dimension: 22.r,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              context.l10n.locationStatusChecking,
              style: AppTypography.subtitleSm.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationStatusErrorCard extends StatelessWidget {
  const _LocationStatusErrorCard({required this.onRefreshPressed});

  final VoidCallback onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.locationStatusCheckFailedTitle,
            style: AppTypography.labelMd.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.h8,
          Text(
            context.l10n.locationStatusCheckFailedSubtitle,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.h16,
          AppButton(
            label: context.l10n.locationStatusRefreshAction,
            onPressed: onRefreshPressed,
          ),
        ],
      ),
    );
  }
}

enum _LocationStatusRowState {
  ready,
  info,
  warning,
}
