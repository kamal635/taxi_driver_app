import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/presentation/controllers/app_update_flow_controller.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_card_surface.dart';

class AppUpdateStatusCard extends ConsumerWidget {
  const AppUpdateStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusState = ref.watch(appUpdateStatusProvider);
    final flowState = ref.watch(appUpdateFlowControllerProvider);

    final statusResult = statusState.asData?.value;
    final activeResult = flowState.result ?? statusResult;
    final isHiddenSameVersion = _isHiddenForSameVersion(
      flowState: flowState,
      result: statusResult,
    );

    if (flowState.isBusy && activeResult != null) {
      return _buildActiveUpdateCard(
        context: context,
        ref: ref,
        flowState: flowState,
        result: activeResult,
      );
    }

    if (flowState.hasError && activeResult != null) {
      return _buildFailedUpdateCard(
        context: context,
        ref: ref,
        flowState: flowState,
        result: activeResult,
      );
    }

    return statusState.when(
      loading: () => _buildLoadingCard(context),
      error: (_, _) => _buildCheckErrorCard(context: context, ref: ref),
      data: (result) {
        if (result.hasUpdate && !isHiddenSameVersion) {
          return _buildAvailableUpdateCard(
            context: context,
            ref: ref,
            result: result,
          );
        }

        if (isHiddenSameVersion) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Text(
              context.l10n.appUpdateInstallerOpenedHint,
              style: AppTypography.subtitleSm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return _buildUpToDateCard(context: context, result: result);
      },
    );
  }

  bool _isHiddenForSameVersion({
    required AppUpdateFlowState flowState,
    required AppUpdateCheckResult? result,
  }) {
    final hiddenVersionCode = flowState.hiddenVersionCode;
    final latestVersionCode = result?.info?.latestVersionCode;

    return hiddenVersionCode != null && latestVersionCode == hiddenVersionCode;
  }

  Widget _buildLoadingCard(BuildContext context) {
    return ProfileCardSurface(
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: const CircularProgressIndicator(strokeWidth: 2.2),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              context.l10n.profileAppUpdateSubtitleChecking,
              style: AppTypography.bodyMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckErrorCard({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return ProfileCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appUpdateCheckFailed,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.h16,
          AppButton(
            label: context.l10n.appUpdateRetryCheck,
            onPressed: () async {
              await ref.read(appUpdateStatusProvider.notifier).refreshStatus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpToDateCard({
    required BuildContext context,
    required AppUpdateCheckResult result,
  }) {
    final version = _resolveCurrentVersionLabel(result);

    return ProfileCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            icon: Icons.verified_rounded,
            iconColor: AppColors.textPrimary,
            iconBackgroundColor: AppColors.bgWarm,
            title: context.l10n.profileAppUpdateTitle,
          ),
          AppSpacing.h12,
          Text(
            context.l10n.profileAppUpdateSubtitleUpToDate(version),
            style: AppTypography.bodyMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableUpdateCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppUpdateCheckResult result,
  }) {
    final info = result.info!;

    return ProfileCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            icon: result.isForceUpdate
                ? Icons.priority_high_rounded
                : Icons.system_update_alt_rounded,
            iconColor: result.isForceUpdate
                ? AppColors.error
                : AppColors.textPrimary,
            iconBackgroundColor: result.isForceUpdate
                ? AppColors.errorBg
                : AppColors.bgWarm,
            title: context.l10n.profileAppUpdateTitle,
          ),
          AppSpacing.h12,
          Text(
            result.isForceUpdate
                ? context.l10n.profileAppUpdateSubtitleRequired(
                    info.latestVersionName,
                  )
                : context.l10n.profileAppUpdateSubtitleAvailable(
                    info.latestVersionName,
                  ),
            style: AppTypography.bodyMd.copyWith(
              color: result.isForceUpdate
                  ? AppColors.error
                  : AppColors.textPrimary,
            ),
          ),
          AppSpacing.h8,
          Text(
            context.l10n.appUpdateCurrentVersionLabel(
              _resolveCurrentVersionLabel(result),
            ),
            style: AppTypography.bodyMuted,
          ),
          AppSpacing.h6,
          Text(
            context.l10n.appUpdateVersionLabel(info.latestVersionName),
            style: AppTypography.bodyMuted,
          ),
          if (info.changelog.isNotEmpty) ...[
            AppSpacing.h12,
            Text(
              info.changelogText,
              style: AppTypography.bodyMuted,
            ),
          ],
          AppSpacing.h16,
          AppButton(
            label: context.l10n.appUpdateAction,
            onPressed: () async {
              await ref
                  .read(appUpdateFlowControllerProvider.notifier)
                  .startOptionalUpdate(result);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUpdateCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppUpdateFlowState flowState,
    required AppUpdateCheckResult result,
  }) {
    final info = result.info!;
    final progressPercent = (flowState.progress * 100).round().clamp(0, 100);

    return ProfileCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            icon: Icons.system_update_alt_rounded,
            iconColor: AppColors.textPrimary,
            iconBackgroundColor: AppColors.bgWarm,
            title: context.l10n.profileAppUpdateTitle,
          ),
          AppSpacing.h12,
          Text(
            context.l10n.profileAppUpdateSubtitleAvailable(
              info.latestVersionName,
            ),
            style: AppTypography.bodyMd,
          ),
          AppSpacing.h8,
          Text(
            context.l10n.appUpdateCurrentVersionLabel(
              _resolveCurrentVersionLabel(result),
            ),
            style: AppTypography.bodyMuted,
          ),
          AppSpacing.h6,
          Text(
            context.l10n.appUpdateVersionLabel(info.latestVersionName),
            style: AppTypography.bodyMuted,
          ),
          if (flowState.isDownloading) ...[
            AppSpacing.h16,
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                minHeight: 8.h,
                value: flowState.progress > 0 ? flowState.progress : null,
              ),
            ),
            AppSpacing.h8,
            Text(
              flowState.progress > 0
                  ? context.l10n.appUpdateDownloadingProgress(progressPercent)
                  : context.l10n.appUpdateDownloading,
              style: AppTypography.bodyMuted,
            ),
            if (!result.isForceUpdate) ...[
              AppSpacing.h16,
              AppButton(
                label: context.l10n.appUpdateCancelDownload,
                backgroundColor: Colors.transparent,
                borderColor: AppColors.border,
                labelColor: AppColors.textPrimary,
                onPressed: () {
                  ref
                      .read(appUpdateFlowControllerProvider.notifier)
                      .cancelOptionalUpdate();
                },
              ),
            ],
          ],
          if (flowState.isInstalling) ...[
            AppSpacing.h16,
            Row(
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(strokeWidth: 2.2),
                ),
                AppSpacing.w12,
                Expanded(
                  child: Text(
                    context.l10n.appUpdateInstalling,
                    style: AppTypography.bodyMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFailedUpdateCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppUpdateFlowState flowState,
    required AppUpdateCheckResult result,
  }) {
    final info = result.info!;

    return ProfileCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.error,
            iconBackgroundColor: AppColors.errorBg,
            title: context.l10n.profileAppUpdateTitle,
          ),
          AppSpacing.h12,
          Text(
            context.l10n.profileAppUpdateSubtitleAvailable(
              info.latestVersionName,
            ),
            style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
          ),
          AppSpacing.h8,
          Text(
            _resolveFlowErrorMessage(context, flowState.error),
            style: AppTypography.bodyMuted.copyWith(color: AppColors.error),
          ),
          AppSpacing.h16,
          AppButton(
            label: context.l10n.appUpdateAction,
            onPressed: () async {
              await ref
                  .read(appUpdateFlowControllerProvider.notifier)
                  .startOptionalUpdate(result);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: iconColor, size: 22.r),
        ),
        AppSpacing.w12,
        Expanded(
          child: Text(
            title,
            style: AppTypography.titleSm,
          ),
        ),
      ],
    );
  }

  String _resolveCurrentVersionLabel(AppUpdateCheckResult result) {
    final currentVersion = result.currentVersionName.trim();
    if (currentVersion.isNotEmpty) {
      return currentVersion;
    }

    final latestVersion = result.info?.latestVersionName.trim();
    return (latestVersion != null && latestVersion.isNotEmpty)
        ? latestVersion
        : '—';
  }

  String _resolveFlowErrorMessage(
    BuildContext context,
    AppUpdateFlowError? error,
  ) {
    return switch (error) {
      AppUpdateFlowError.urlNotReady => context.l10n.appUpdateUrlNotReady,
      AppUpdateFlowError.invalidPackage => context.l10n.appUpdateInvalidPackage,
      AppUpdateFlowError.downloadFailed => context.l10n.appUpdateDownloadFailed,
      AppUpdateFlowError.installFailed => context.l10n.appUpdateInstallFailed,
      null => context.l10n.errorUnexpected,
    };
  }
}
