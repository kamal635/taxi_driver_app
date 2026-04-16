import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_install_failure.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';

enum AppUpdateFlowPhase {
  idle,
  downloading,
  installing,
  failed,
}

class AppUpdateFlowState {
  const AppUpdateFlowState({
    this.phase = AppUpdateFlowPhase.idle,
    this.progress = 0,
    this.result,
    this.error,
    this.hiddenVersionCode,
  });

  final AppUpdateFlowPhase phase;
  final double progress;
  final AppUpdateCheckResult? result;
  final AppUpdateInstallFailure? error;
  final int? hiddenVersionCode;

  bool get isBusy =>
      phase == AppUpdateFlowPhase.downloading ||
      phase == AppUpdateFlowPhase.installing;

  bool get isDownloading => phase == AppUpdateFlowPhase.downloading;
  bool get isInstalling => phase == AppUpdateFlowPhase.installing;
  bool get hasError => phase == AppUpdateFlowPhase.failed && error != null;

  AppUpdateFlowState copyWith({
    AppUpdateFlowPhase? phase,
    double? progress,
    AppUpdateCheckResult? result,
    bool clearResult = false,
    AppUpdateInstallFailure? error,
    bool clearError = false,
    int? hiddenVersionCode,
    bool clearHiddenVersionCode = false,
  }) {
    return AppUpdateFlowState(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      hiddenVersionCode: clearHiddenVersionCode
          ? null
          : (hiddenVersionCode ?? this.hiddenVersionCode),
    );
  }
}

/// Controls the optional in-app update flow shown from the profile section.
class AppUpdateFlowController extends Notifier<AppUpdateFlowState> {
  CancelToken? _cancelToken;

  @override
  AppUpdateFlowState build() {
    ref.onDispose(() {
      _cancelToken?.cancel('app_update_flow_disposed');
      _cancelToken = null;
    });

    return const AppUpdateFlowState();
  }

  Future<void> startOptionalUpdate(AppUpdateCheckResult result) async {
    if (state.isBusy) {
      return;
    }

    final info = result.info;
    if (info == null) {
      return;
    }

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    state = state.copyWith(
      phase: AppUpdateFlowPhase.downloading,
      progress: 0,
      result: result,
      clearError: true,
      clearHiddenVersionCode: true,
    );

    try {
      await ref
          .read(appUpdateInstallerServiceProvider)
          .installUpdate(
            info: info,
            cancelToken: cancelToken,
            onDownloadProgress: (progress) {
              state = state.copyWith(
                phase: AppUpdateFlowPhase.downloading,
                progress: progress,
                result: result,
                clearError: true,
              );
            },
            onInstalling: () {
              state = state.copyWith(
                phase: AppUpdateFlowPhase.installing,
                progress: 1,
                result: result,
                clearError: true,
              );
            },
          );

      state = AppUpdateFlowState(
        hiddenVersionCode: info.latestVersionCode,
      );
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        state = state.copyWith(
          phase: AppUpdateFlowPhase.idle,
          progress: 0,
          result: result,
          clearError: true,
          clearHiddenVersionCode: true,
        );
        return;
      }

      state = state.copyWith(
        phase: AppUpdateFlowPhase.failed,
        progress: 0,
        result: result,
        error: AppUpdateInstallFailure.downloadFailed,
      );
    } on AppUpdateInstallerException catch (exception) {
      state = state.copyWith(
        phase: AppUpdateFlowPhase.failed,
        progress: 0,
        result: result,
        error: exception.failure,
      );
    } finally {
      if (identical(_cancelToken, cancelToken)) {
        _cancelToken = null;
      }
    }
  }

  void cancelOptionalUpdate() {
    if (!state.isDownloading) {
      return;
    }

    _cancelToken?.cancel('optional_update_cancelled');
    _cancelToken = null;

    state = state.copyWith(
      phase: AppUpdateFlowPhase.idle,
      progress: 0,
      clearError: true,
      clearHiddenVersionCode: true,
    );
  }

  void clearInstallerHint() {
    if (state.hiddenVersionCode == null) {
      return;
    }

    state = state.copyWith(
      phase: AppUpdateFlowPhase.idle,
      progress: 0,
      clearError: true,
      clearHiddenVersionCode: true,
      clearResult: true,
    );
  }
}
