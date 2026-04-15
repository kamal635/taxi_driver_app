import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';

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
      icon: Icons.system_update_alt_rounded,
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
  String? _errorMessage;
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
    if (info == null) return;

    if (!info.hasDownloadUrl && !info.hasDriveFileId) {
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.appUpdateUrlNotReady;
      });
      return;
    }

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    setState(() {
      _phase = _ForceAppUpdatePhase.downloading;
      _progress = 0;
      _errorMessage = null;
    });

    try {
      final apkFile = await ref
          .read(appUpdateServiceProvider)
          .downloadApk(
            info: info,
            cancelToken: cancelToken,
            onProgress: (progress) {
              if (!mounted) return;
              setState(() {
                _progress = progress;
              });
            },
          );

      final bytes = await apkFile.readAsBytes();
      final isZipLike =
          bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;

      if (!isZipLike) {
        if (!mounted) return;
        setState(() {
          _phase = _ForceAppUpdatePhase.idle;
          _errorMessage = context.l10n.appUpdateInvalidPackage;
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        _phase = _ForceAppUpdatePhase.installing;
        _progress = 1;
      });

      await ref.read(apkInstallServiceProvider).install(apkFile);

      if (!mounted) return;
      Navigator.of(context).pop(AppUpdateDialogAction.update);
    } on DioException catch (error) {
      if (!mounted) return;

      if (error.type == DioExceptionType.cancel) {
        setState(() {
          _phase = _ForceAppUpdatePhase.idle;
          _progress = 0;
          _errorMessage = null;
        });
        return;
      }

      setState(() {
        _phase = _ForceAppUpdatePhase.idle;
        _errorMessage = context.l10n.appUpdateDownloadFailed;
      });
    } on Exception {
      if (!mounted) return;

      setState(() {
        _phase = _ForceAppUpdatePhase.idle;
        _errorMessage = context.l10n.appUpdateInstallFailed;
      });
    } finally {
      _cancelToken = null;
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
              Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: AppColors.infoBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.system_update_alt_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Text(
                      l10n.appUpdateTitle,
                      style: AppTypography.titleSm,
                    ),
                  ),
                ],
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
              if (_errorMessage != null) ...[
                AppSpacing.h12,
                Text(
                  _errorMessage!,
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
