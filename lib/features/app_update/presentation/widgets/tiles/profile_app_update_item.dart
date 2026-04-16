import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_names.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/presentation/controllers/app_update_flow_controller.dart';
import 'package:taxi_driver_app/features/app_update/presentation/helpers/app_update_text_resolver.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile/profile_section_item.dart';

/// Profile entry point for the app update flow.
class ProfileAppUpdateItem extends ConsumerWidget {
  const ProfileAppUpdateItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusState = ref.watch(appUpdateStatusProvider);
    final flowState = ref.watch(appUpdateFlowControllerProvider);

    final appearance = _buildAppearance(
      context: context,
      state: statusState,
      flowState: flowState,
    );

    return ProfileSectionItem(
      title: context.l10n.profileAppUpdateTitle,
      subtitle: appearance.subtitle,
      icon: AppIcons.update,
      accentColor: appearance.accentColor,
      iconBackgroundColor: appearance.iconBackgroundColor,
      subtitleColor: appearance.subtitleColor,
      trailing: appearance.trailing,
      onPressed: () async {
        await context.pushNamed(AppRouteNames.profileAppUpdate);
      },
    );
  }

  _ProfileAppUpdateAppearance _buildAppearance({
    required BuildContext context,
    required AsyncValue<AppUpdateCheckResult> state,
    required AppUpdateFlowState flowState,
  }) {
    final statusResult = state.asData?.value;
    final isHiddenSameVersion = AppUpdateTextResolver.isInstallerHintHidden(
      flowState: flowState,
      result: statusResult,
    );

    if (flowState.isDownloading) {
      final progressPercent = (flowState.progress * 100).round().clamp(0, 100);

      return _ProfileAppUpdateAppearance(
        subtitle: flowState.progress > 0
            ? context.l10n.appUpdateDownloadingProgress(progressPercent)
            : context.l10n.appUpdateDownloading,
        accentColor: AppColors.textPrimary,
        iconBackgroundColor: AppColors.bgWarm,
        subtitleColor: AppColors.textSecondary,
        trailing: const _AnimatedDownloadTrailingIcon(),
      );
    }

    if (flowState.isInstalling) {
      return _ProfileAppUpdateAppearance(
        subtitle: context.l10n.appUpdateInstalling,
        accentColor: AppColors.textPrimary,
        iconBackgroundColor: AppColors.bgWarm,
        subtitleColor: AppColors.textSecondary,
        trailing: const _AnimatedDownloadTrailingIcon(),
      );
    }

    if (flowState.hasError) {
      return _ProfileAppUpdateAppearance(
        subtitle: context.l10n.profileAppUpdateSubtitleRetry,
        accentColor: AppColors.error,
        iconBackgroundColor: AppColors.errorBg,
        subtitleColor: AppColors.error,
        trailing: Icon(
          AppIcons.refresh,
          size: 18.r,
          color: AppColors.error,
        ),
      );
    }

    return state.when(
      loading: () => _ProfileAppUpdateAppearance(
        subtitle: context.l10n.profileAppUpdateSubtitleChecking,
        accentColor: AppColors.textPrimary,
        iconBackgroundColor: AppColors.bgWarm,
        subtitleColor: AppColors.textSecondary,
      ),
      error: (_, _) => _ProfileAppUpdateAppearance(
        subtitle: context.l10n.profileAppUpdateSubtitleRetry,
        accentColor: AppColors.textPrimary,
        iconBackgroundColor: AppColors.bgWarm,
        subtitleColor: AppColors.textSecondary,
      ),
      data: (result) {
        final info = result.info;

        if (result.isForceUpdate && info != null) {
          return _ProfileAppUpdateAppearance(
            subtitle: context.l10n.profileAppUpdateSubtitleRequired(
              info.latestVersionName,
            ),
            accentColor: AppColors.error,
            iconBackgroundColor: AppColors.errorBg,
            subtitleColor: AppColors.error,
          );
        }

        if (result.hasUpdate && info != null && !isHiddenSameVersion) {
          return _ProfileAppUpdateAppearance(
            subtitle: context.l10n.profileAppUpdateSubtitleAvailable(
              info.latestVersionName,
            ),
            accentColor: AppColors.textPrimary,
            iconBackgroundColor: AppColors.bgWarm,
            subtitleColor: AppColors.textSecondary,
          );
        }

        final versionLabel = AppUpdateTextResolver.resolveCurrentVersionLabel(
          result,
        );

        return _ProfileAppUpdateAppearance(
          subtitle: context.l10n.profileAppUpdateSubtitleUpToDate(versionLabel),
        );
      },
    );
  }
}

class _ProfileAppUpdateAppearance {
  const _ProfileAppUpdateAppearance({
    required this.subtitle,
    this.accentColor,
    this.iconBackgroundColor,
    this.subtitleColor,
    this.trailing,
  });

  final String subtitle;
  final Color? accentColor;
  final Color? iconBackgroundColor;
  final Color? subtitleColor;
  final Widget? trailing;
}

class _AnimatedDownloadTrailingIcon extends StatefulWidget {
  const _AnimatedDownloadTrailingIcon();

  @override
  State<_AnimatedDownloadTrailingIcon> createState() =>
      _AnimatedDownloadTrailingIconState();
}

class _AnimatedDownloadTrailingIconState
    extends State<_AnimatedDownloadTrailingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _translateY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    unawaited(_controller.repeat());

    _opacity =
        Tween<double>(
          begin: 1,
          end: 0.20,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );

    _translateY =
        Tween<double>(
          begin: -2,
          end: 6,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translateY.value),
            child: child,
          ),
        );
      },
      child: Icon(
        AppIcons.download,
        size: 22.r,
        color: AppColors.primary,
      ),
    );
  }
}
