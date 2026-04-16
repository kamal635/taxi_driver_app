import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:taxi_driver_app/features/app_update/data/models/app_update_info.dart';
import 'package:taxi_driver_app/features/app_update/data/services/apk_install_service.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_install_failure.dart';

/// Orchestrates the full APK installation flow.
///
/// This keeps download, validation and installation logic out of the widgets
/// and prevents duplicated update code between optional and forced flows.
class AppUpdateInstallerService {
  AppUpdateInstallerService(
    this._updateService,
    this._apkInstallService,
  );

  final AppUpdateService _updateService;
  final ApkInstallService _apkInstallService;

  static const int _zipSignatureFirstByte = 0x50;
  static const int _zipSignatureSecondByte = 0x4B;

  Future<void> installUpdate({
    required AppUpdateInfo info,
    required void Function(double progress) onDownloadProgress,
    void Function()? onInstalling,
    CancelToken? cancelToken,
  }) async {
    if (!info.hasDownloadUrl && !info.hasDriveFileId) {
      throw const AppUpdateInstallerException(
        AppUpdateInstallFailure.urlNotReady,
      );
    }

    try {
      final apkFile = await _updateService.downloadApk(
        info: info,
        cancelToken: cancelToken,
        onProgress: onDownloadProgress,
      );

      final isValidPackage = await _hasValidApkSignature(apkFile);
      if (!isValidPackage) {
        throw const AppUpdateInstallerException(
          AppUpdateInstallFailure.invalidPackage,
        );
      }

      onInstalling?.call();
      await _apkInstallService.install(apkFile);
    } on AppUpdateInstallerException {
      rethrow;
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        rethrow;
      }

      throw const AppUpdateInstallerException(
        AppUpdateInstallFailure.downloadFailed,
      );
    } on Exception {
      throw const AppUpdateInstallerException(
        AppUpdateInstallFailure.installFailed,
      );
    }
  }

  Future<bool> _hasValidApkSignature(File file) async {
    final headerBytes = await file
        .openRead(0, 4)
        .fold<List<int>>(
          <int>[],
          (buffer, chunk) => buffer..addAll(chunk),
        );

    return headerBytes.length >= 2 &&
        headerBytes[0] == _zipSignatureFirstByte &&
        headerBytes[1] == _zipSignatureSecondByte;
  }
}
