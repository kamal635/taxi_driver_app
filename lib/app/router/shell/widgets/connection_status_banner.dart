import 'dart:async' show Timer;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/connectivity/connectivity_providers.dart';
import 'package:bawabat_al_saeq/core/connectivity/connectivity_status.dart';
import 'package:bawabat_al_saeq/core/constants/app_durations.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectionStatusBanner extends ConsumerStatefulWidget {
  const ConnectionStatusBanner({super.key});

  @override
  ConsumerState<ConnectionStatusBanner> createState() =>
      _ConnectionStatusBannerState();
}

class _ConnectionStatusBannerState
    extends ConsumerState<ConnectionStatusBanner> {
  static const _restoredVisibleDuration = Duration(seconds: 3);

  ProviderSubscription<AsyncValue<AppConnectivityStatus>>? _subscription;
  Timer? _restoredTimer;
  AppConnectivityStatus? _lastStatus;
  bool _showRestored = false;

  @override
  void initState() {
    super.initState();

    _subscription = ref.listenManual<AsyncValue<AppConnectivityStatus>>(
      connectivityStatusProvider,
      _handleStatusChanged,
      fireImmediately: true,
    );
  }

  void _handleStatusChanged(
    AsyncValue<AppConnectivityStatus>? _,
    AsyncValue<AppConnectivityStatus> next,
  ) {
    final status = next.asData?.value;
    if (status == null) return;

    final wasDisconnected = _lastStatus == AppConnectivityStatus.disconnected;
    _lastStatus = status;

    if (status == AppConnectivityStatus.disconnected) {
      _restoredTimer?.cancel();
      _restoredTimer = null;

      if (_showRestored && mounted) {
        setState(() => _showRestored = false);
      }

      return;
    }

    if (!wasDisconnected) return;

    _restoredTimer?.cancel();

    if (mounted) {
      setState(() => _showRestored = true);
    }

    _restoredTimer = Timer(_restoredVisibleDuration, () {
      if (!mounted) return;
      setState(() => _showRestored = false);
    });
  }

  @override
  void dispose() {
    _subscription?.close();
    _restoredTimer?.cancel();
    _subscription = null;
    _restoredTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectivityStatusProvider).asData?.value;
    final isDisconnected = status == AppConnectivityStatus.disconnected;

    if (!isDisconnected && !_showRestored) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final colors = context.colors;
    final style = isDisconnected
        ? _ConnectionBannerStyle(
            icon: Icons.wifi_off_rounded,
            title: l10n.connectionOfflineTitle,
            subtitle: l10n.connectionOfflineSubtitle,
            backgroundColor: colors.warningBg,
            foregroundColor: colors.warning,
            borderColor: colors.warning.withValues(alpha: 0.20),
          )
        : _ConnectionBannerStyle(
            icon: AppIcons.success,
            title: l10n.connectionRestoredTitle,
            subtitle: l10n.connectionRestoredSubtitle,
            backgroundColor: colors.successBg,
            foregroundColor: colors.success,
            borderColor: colors.success.withValues(alpha: 0.20),
          );

    return AnimatedSwitcher(
      duration: AppDurations.normal,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Padding(
        key: ValueKey(style.title),
        padding: EdgeInsets.only(top: 8.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: style.borderColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  style.icon,
                  color: style.foregroundColor,
                  size: 22.r,
                ),
                AppSpacing.w10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.title,
                        style: AppTypography.labelMd.copyWith(
                          color: style.foregroundColor,
                        ),
                      ),
                      AppSpacing.h4,
                      Text(
                        style.subtitle,
                        style: AppTypography.bodyMuted.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionBannerStyle {
  const _ConnectionBannerStyle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}
