import 'dart:io';

import 'package:apk_sideload/install_apk.dart';

class ApkInstallService {
  ApkInstallService();

  final InstallApk _installer = InstallApk();

  Future<void> install(File apkFile) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('APK install is supported on Android only.');
    }

    await _installer.installApk(apkFile.path);
  }
}
