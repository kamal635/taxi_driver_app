import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_install_failure.dart';
import 'package:taxi_driver_app/features/app_update/presentation/helpers/app_update_text_resolver.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';
import 'package:taxi_driver_app/features/app_update/presentation/widgets/common/app_update_card_header.dart';

enum AppUpdateDialogAction {
  later,
  update,
}

enum _ForceAppUpdatePhase {
  idle,
  downloading,
  installing,
}

Future<AppUpdateDialogAction> showAppUpdateDialog({
  required BuildContext context,
  required AppUpdateCheckResult result,
}) async {
  final info = result.info;
  if (info == null) {
    return AppUpdateDialogAction.later;
  }

  if (!result.isForceUpdate) {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: context.l10n.appUpdateTitle,
      message:
          '${context.l10n.appUpdateVersionLabel(info.latestVersionName)}\n\n'
          '${info.changelogText}',
      confirmLabel: context.l10n.appUpdateAction,
      cancelLabel: context.l10n.appUpdateLater,
      barrierDismissible: true,
      icon: AppIcons.update,
      iconColor: AppColors.primary,
      backgroundColorIcon: AppColors.infoBg,
    );

    return confirmed
        ? AppUpdateDialogAction.update
        : AppUpdateDialogAction.later;
  }

  final dialogResult = await showDialog<AppUpdateDialogAction>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ForceAppUpdateDialog(result: result),
  );

  return dialogResult ?? AppUpdateDialogAction.later;
}

class _ForceAppUpdateDialog extends ConsumerStatefulWidget {
  const _ForceAppUpdateDialog({
    required this.result,
  });

  final AppUpdateCheckResult result;

  @override
  ConsumerState<_ForceAppUpdateDialog> createState() =>
      _ForceAppUpdateDialogState();
}

class _ForceAppUpdateDialogState extends ConsumerState<_ForceAppUpdateDialog> {
  _ForceAppUpdatePhase _phase = _ForceAppUpdatePhase.idle;
  double _progress = 0;
  AppUpdateInstallFailure? _error;
  CancelToken? _cancelToken;

  AppUpdateCheckResult get _result => widget.result;

  bool get _isDownloading => _phase == _ForceAppUpdatePhase.downloading;
  bool get _isInstalling => _phase == _ForceAppUpdatePhase.installing;
  bool get _isBusy => _isDownloading || _isInstalling;

  @override
  void dispose() {
    _cancelToken?.cancel('dialog_disposed');
    _cancelToken = null;
    super.dispose();
  }

  Future<void> _startForceUpdate() async {
    final info = _result.info;
    if (info == null) {
      return;
    }

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    setState(() {
      _phase = _ForceAppUpdatePhase.downloading;
      _progress = 0;
      _error = null;
    });

    try {
      await ref
          .read(appUpdateInstallerServiceProvider)
          .installUpdate(
            info: info,
            cancelToken: cancelToken,
            onDownloadProgress: (progress) {
              if (!mounted) {
                return;
              }

              setState(() {
                _progress = progress;
              });
            },
            onInstalling: () {
              if (!mounted) {
                return;
              }

              setState(() {
                _phase = _ForceAppUpdatePhase.installing;
                _progress = 1;
              });
            },
          );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(AppUpdateDialogAction.update);
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      if (CancelToken.isCancel(error)) {
        setState(() {
          _phase = _ForceAppUpdatePhase.idle;
          _progress = 0;
          _error = null;
        });
        return;
      }

      setState(() {
        _phase = _ForceAppUpdatePhase.idle;
        _error = AppUpdateInstallFailure.downloadFailed;
      });
    } on AppUpdateInstallerException catch (exception) {
      if (!mounted) {
        return;
      }

      setState(() {
        _phase = _ForceAppUpdatePhase.idle;
        _error = exception.failure;
      });
    } finally {
      if (identical(_cancelToken, cancelToken)) {
        _cancelToken = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info = _result.info!;
    final progressPercent = (_progress * 100).round().clamp(0, 100);

    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUpdateCardHeader(
                icon: AppIcons.update,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.infoBg,
                title: l10n.appUpdateTitle,
              ),
              AppSpacing.h12,
              Text(
                l10n.appUpdateVersionLabel(info.latestVersionName),
                style: AppTypography.bodyMuted,
              ),
              if (info.changelog.isNotEmpty) ...[
                AppSpacing.h8,
                Text(
                  info.changelogText,
                  style: AppTypography.bodyMuted,
                ),
              ],
              if (_isDownloading) ...[
                AppSpacing.h16,
                ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    minHeight: 8.h,
                    value: _progress > 0 ? _progress : null,
                  ),
                ),
                AppSpacing.h8,
                Text(
                  _progress > 0
                      ? l10n.appUpdateDownloadingProgress(progressPercent)
                      : l10n.appUpdateDownloading,
                  style: AppTypography.bodyMuted,
                ),
              ],
              if (_isInstalling) ...[
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
                        l10n.appUpdateInstalling,
                        style: AppTypography.bodyMuted,
                      ),
                    ),
                  ],
                ),
              ],
              if (_error != null) ...[
                AppSpacing.h12,
                Text(
                  AppUpdateTextResolver.resolveFlowErrorMessage(
                    context,
                    _error,
                  ),
                  style: AppTypography.bodyMuted.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
              AppSpacing.h16,
              AppButton(
                label: _isInstalling
                    ? l10n.appUpdateInstalling
                    : _isDownloading
                    ? l10n.appUpdateDownloading
                    : l10n.appUpdateAction,
                onPressed: _isBusy ? null : _startForceUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
