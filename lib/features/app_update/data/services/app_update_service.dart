import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taxi_driver_app/features/app_update/data/models/app_update_info.dart';
import 'package:taxi_driver_app/features/app_update/data/models/drive_file_metadata.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/domain/update_status.dart';

/// Remote service responsible for checking versions and downloading APK files.
class AppUpdateService {
  AppUpdateService(this._dio);

  final Dio _dio;

  static const String _driveApiKey = 'AIzaSyBIKAI4tl9jCpUE9c1QdCYzeJYjtvw72JI';
  static const String _driveMetadataFields =
      'id,name,webContentLink,resourceKey,capabilities(canDownload)';
  static const String _updateManifestUrl =
      'https://drive.google.com/uc?export=download&id=1cgAkOBP9tKutPcGyW0iv3bn_1NnM1aj5';
  static const String _downloadDirectoryName = 'app_update';
  static const String _apkFileNamePrefix = 'taxi_driver_app';

  Future<AppUpdateCheckResult> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final rawVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    final currentVersionCode = _normalizeVersionCode(rawVersionCode);
    final currentVersionName = packageInfo.version.trim();

    try {
      final response = await _dio.get<String>(
        _updateManifestUrl,
        options: Options(responseType: ResponseType.plain),
      );

      final rawManifest = response.data?.trim();
      if (rawManifest == null || rawManifest.isEmpty) {
        return _buildNoUpdateResult(
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      final jsonMap = jsonDecode(rawManifest) as Map<String, dynamic>;
      final info = AppUpdateInfo.fromJson(jsonMap);

      if (currentVersionCode >= info.latestVersionCode) {
        return AppUpdateCheckResult(
          status: UpdateStatus.noUpdate,
          info: info,
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      final mustForceUpdate =
          info.forceUpdate || currentVersionCode < info.minSupportedVersionCode;

      return AppUpdateCheckResult(
        status: mustForceUpdate
            ? UpdateStatus.forceUpdate
            : UpdateStatus.optionalUpdate,
        info: info,
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
      );
    } on Exception {
      return _buildNoUpdateResult(
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
      );
    }
  }

  Future<DriveFileMetadata> fetchDriveFileMetadata(String fileId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://www.googleapis.com/drive/v3/files/$fileId',
      queryParameters: const {
        'fields': _driveMetadataFields,
        'key': _driveApiKey,
      },
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Drive metadata response is empty');
    }

    return DriveFileMetadata.fromJson(data);
  }

  Future<File> downloadApk({
    required AppUpdateInfo info,
    required void Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    if (info.hasDriveFileId) {
      return _downloadDriveApk(
        info: info,
        onProgress: onProgress,
        cancelToken: cancelToken,
      );
    }

    if (!info.hasDownloadUrl) {
      throw const FormatException('APK url is not ready');
    }

    final file = await _prepareDownloadFile(info.latestVersionName);

    await _dio.download(
      info.apkUrl,
      file.path,
      cancelToken: cancelToken,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(minutes: 10),
      ),
      onReceiveProgress: (received, total) {
        if (total <= 0) {
          return;
        }

        onProgress(received / total);
      },
    );

    return file;
  }

  Future<File> _downloadDriveApk({
    required AppUpdateInfo info,
    required void Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    if (!info.hasDriveFileId) {
      throw const FormatException('Drive file id is not ready');
    }

    final metadata = await fetchDriveFileMetadata(info.apkFileId);

    if (!metadata.canDownload) {
      throw const FormatException('Drive file cannot be downloaded');
    }

    final file = await _prepareDownloadFile(info.latestVersionName);
    final headers = <String, dynamic>{};

    if ((metadata.resourceKey ?? '').isNotEmpty) {
      headers['X-Goog-Drive-Resource-Keys'] =
          '${metadata.id}/${metadata.resourceKey}';
    }

    await _dio.download(
      'https://www.googleapis.com/drive/v3/files/${metadata.id}',
      file.path,
      cancelToken: cancelToken,
      queryParameters: const {
        'alt': 'media',
        'key': _driveApiKey,
      },
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        headers: headers,
        receiveTimeout: const Duration(minutes: 10),
      ),
      onReceiveProgress: (received, total) {
        if (total <= 0) {
          return;
        }

        onProgress(received / total);
      },
    );

    return file;
  }

  Future<File> _prepareDownloadFile(String versionName) async {
    final tempDir = await getTemporaryDirectory();
    final updateDir = Directory('${tempDir.path}/$_downloadDirectoryName');

    if (!updateDir.existsSync()) {
      updateDir.createSync(recursive: true);
    }

    final file = File(
      '${updateDir.path}/$_apkFileNamePrefix$versionName.apk',
    );

    if (file.existsSync()) {
      file.deleteSync();
    }

    return file;
  }

  AppUpdateCheckResult _buildNoUpdateResult({
    required int currentVersionCode,
    required String currentVersionName,
  }) {
    return AppUpdateCheckResult(
      status: UpdateStatus.noUpdate,
      info: null,
      currentVersionCode: currentVersionCode,
      currentVersionName: currentVersionName,
    );
  }

  int _normalizeVersionCode(int rawVersionCode) {
    if (rawVersionCode >= 1000) {
      return rawVersionCode % 1000;
    }

    return rawVersionCode;
  }
}
