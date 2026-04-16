import 'package:flutter/widgets.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_install_failure.dart';
import 'package:taxi_driver_app/features/app_update/presentation/controllers/app_update_flow_controller.dart';

/// Centralized text and state helpers for the update UI.
final class AppUpdateTextResolver {
  const AppUpdateTextResolver._();

  static bool isInstallerHintHidden({
    required AppUpdateFlowState flowState,
    required AppUpdateCheckResult? result,
  }) {
    final hiddenVersionCode = flowState.hiddenVersionCode;
    final latestVersionCode = result?.info?.latestVersionCode;

    return hiddenVersionCode != null && latestVersionCode == hiddenVersionCode;
  }

  static String resolveCurrentVersionLabel(AppUpdateCheckResult result) {
    final currentVersion = result.currentVersionName.trim();
    if (currentVersion.isNotEmpty) {
      return currentVersion;
    }

    final latestVersion = result.info?.latestVersionName.trim();
    return (latestVersion != null && latestVersion.isNotEmpty)
        ? latestVersion
        : '—';
  }

  static String resolveFlowErrorMessage(
    BuildContext context,
    AppUpdateInstallFailure? error,
  ) {
    return switch (error) {
      AppUpdateInstallFailure.urlNotReady => context.l10n.appUpdateUrlNotReady,
      AppUpdateInstallFailure.invalidPackage =>
        context.l10n.appUpdateInvalidPackage,
      AppUpdateInstallFailure.downloadFailed =>
        context.l10n.appUpdateDownloadFailed,
      AppUpdateInstallFailure.installFailed =>
        context.l10n.appUpdateInstallFailed,
      null => context.l10n.errorUnexpected,
    };
  }
}
