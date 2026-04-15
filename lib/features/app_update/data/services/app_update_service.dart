import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taxi_driver_app/features/app_update/data/models/app_update_info.dart';
import 'package:taxi_driver_app/features/app_update/data/models/drive_file_metadata.dart';
import 'package:taxi_driver_app/features/app_update/domain/update_status.dart';

class AppUpdateCheckResult {
  const AppUpdateCheckResult({
    required this.status,
    required this.info,
    required this.currentVersionCode,
    required this.currentVersionName,
  });

  final UpdateStatus status;
  final AppUpdateInfo? info;
  final int currentVersionCode;
  final String currentVersionName;

  bool get hasUpdate => status != UpdateStatus.noUpdate && info != null;
  bool get isForceUpdate => status == UpdateStatus.forceUpdate;
}

class AppUpdateService {
  AppUpdateService(this._dio);

  final Dio _dio;

  static const String driveApiKey = 'AIzaSyBIKAI4tl9jCpUE9c1QdCYzeJYjtvw72JI';

  static const String _driveMetadataFields =
      'id,name,webContentLink,resourceKey,capabilities(canDownload)';

  static const String updateUrl =
      'https://drive.google.com/uc?export=download&id=1cgAkOBP9tKutPcGyW0iv3bn_1NnM1aj5';

  Future<AppUpdateCheckResult> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final rawVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    final currentVersionCode = _normalizeVersionCode(rawVersionCode);
    final currentVersionName = packageInfo.version.trim();

    try {
      final response = await _dio.get<String>(
        updateUrl,
        options: Options(responseType: ResponseType.plain),
      );

      final raw = response.data;
      if (raw == null || raw.isEmpty) {
        return AppUpdateCheckResult(
          status: UpdateStatus.noUpdate,
          info: null,
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
      final info = AppUpdateInfo.fromJson(jsonMap);

      if (currentVersionCode >= info.latestVersionCode) {
        return AppUpdateCheckResult(
          status: UpdateStatus.noUpdate,
          info: info,
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      if (info.forceUpdate ||
          currentVersionCode < info.minSupportedVersionCode) {
        return AppUpdateCheckResult(
          status: UpdateStatus.forceUpdate,
          info: info,
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      return AppUpdateCheckResult(
        status: UpdateStatus.optionalUpdate,
        info: info,
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
      );
    } on Exception {
      return AppUpdateCheckResult(
        status: UpdateStatus.noUpdate,
        info: null,
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
      );
    }
  }

  Future<DriveFileMetadata> fetchDriveFileMetadata(String fileId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://www.googleapis.com/drive/v3/files/$fileId',
      queryParameters: {
        'fields': _driveMetadataFields,
        'key': driveApiKey,
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
      return downloadDriveApk(
        info: info,
        onProgress: onProgress,
        cancelToken: cancelToken,
      );
    }

    if (!info.hasDownloadUrl) {
      throw const FormatException('APK url is not ready');
    }

    final tempDir = await getTemporaryDirectory();
    final updateDir = Directory('${tempDir.path}/app_update');

    if (!updateDir.existsSync()) {
      updateDir.createSync(recursive: true);
    }

    final file = File(
      '${updateDir.path}/taxi_driver_app_${info.latestVersionName}.apk',
    );

    if (file.existsSync()) {
      file.deleteSync();
    }

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
        if (total <= 0) return;
        onProgress(received / total);
      },
    );

    return file;
  }

  Future<File> downloadDriveApk({
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

    final tempDir = await getTemporaryDirectory();
    final updateDir = Directory('${tempDir.path}/app_update');

    if (!updateDir.existsSync()) {
      updateDir.createSync(recursive: true);
    }

    final file = File(
      '${updateDir.path}/taxi_driver_app_${info.latestVersionName}.apk',
    );

    if (file.existsSync()) {
      file.deleteSync();
    }

    final headers = <String, dynamic>{};

    if ((metadata.resourceKey ?? '').isNotEmpty) {
      headers['X-Goog-Drive-Resource-Keys'] =
          '${metadata.id}/${metadata.resourceKey}';
    }

    await _dio.download(
      'https://www.googleapis.com/drive/v3/files/${metadata.id}',
      file.path,
      cancelToken: cancelToken,
      queryParameters: {
        'alt': 'media',
        'key': driveApiKey,
      },
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        headers: headers,
        receiveTimeout: const Duration(minutes: 10),
      ),
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        onProgress(received / total);
      },
    );

    return file;
  }

  int _normalizeVersionCode(int rawVersionCode) {
    if (rawVersionCode >= 1000) {
      return rawVersionCode % 1000;
    }
    return rawVersionCode;
  }
}
