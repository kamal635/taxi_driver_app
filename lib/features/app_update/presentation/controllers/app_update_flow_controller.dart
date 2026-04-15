import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';

const _apkSignatureFirstByte = 0x50;
const _apkSignatureSecondByte = 0x4B;

enum AppUpdateFlowPhase {
  idle,
  downloading,
  installing,
  failed,
}

enum AppUpdateFlowError {
  urlNotReady,
  invalidPackage,
  downloadFailed,
  installFailed,
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
  final AppUpdateFlowError? error;
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
    AppUpdateFlowError? error,
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

class AppUpdateFlowController extends Notifier<AppUpdateFlowState> {
  AppUpdateService get _updateService => ref.read(appUpdateServiceProvider);

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

    if (!info.hasDownloadUrl && !info.hasDriveFileId) {
      state = state.copyWith(
        phase: AppUpdateFlowPhase.failed,
        progress: 0,
        result: result,
        error: AppUpdateFlowError.urlNotReady,
        clearHiddenVersionCode: true,
      );
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
      final apkFile = await _updateService.downloadApk(
        info: info,
        cancelToken: cancelToken,
        onProgress: (progress) {
          state = state.copyWith(
            phase: AppUpdateFlowPhase.downloading,
            progress: progress,
            result: result,
            clearError: true,
          );
        },
      );

      final bytes = await apkFile.readAsBytes();
      final isZipLike =
          bytes.length >= 4 &&
          bytes[0] == _apkSignatureFirstByte &&
          bytes[1] == _apkSignatureSecondByte;

      if (!isZipLike) {
        state = state.copyWith(
          phase: AppUpdateFlowPhase.failed,
          progress: 0,
          result: result,
          error: AppUpdateFlowError.invalidPackage,
        );
        return;
      }

      state = state.copyWith(
        phase: AppUpdateFlowPhase.installing,
        progress: 1,
        result: result,
        clearError: true,
      );

      await ref.read(apkInstallServiceProvider).install(apkFile);

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
        error: AppUpdateFlowError.downloadFailed,
      );
    } on Exception {
      state = state.copyWith(
        phase: AppUpdateFlowPhase.failed,
        progress: 0,
        result: result,
        error: AppUpdateFlowError.installFailed,
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
