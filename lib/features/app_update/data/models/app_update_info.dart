class AppUpdateInfo {
  const AppUpdateInfo({
    required this.latestVersionName,
    required this.latestVersionCode,
    required this.minSupportedVersionCode,
    required this.forceUpdate,
    required this.apkUrl,
    required this.changelog,
    required this.apkFileId,
  });

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    final android = json['android'] as Map<String, dynamic>;

    return AppUpdateInfo(
      latestVersionName: android['latestVersionName'] as String,
      latestVersionCode: android['latestVersionCode'] as int,
      minSupportedVersionCode: android['minSupportedVersionCode'] as int,
      forceUpdate: android['forceUpdate'] as bool,
      apkUrl: android['apkUrl'] as String? ?? '',
      apkFileId: android['apkFileId'] as String? ?? '',
      changelog: (android['changelog'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  final String latestVersionName;
  final int latestVersionCode;
  final int minSupportedVersionCode;
  final bool forceUpdate;
  final String apkUrl;
  final String apkFileId;
  final List<String> changelog;

  bool get hasDownloadUrl {
    final value = apkUrl.trim();
    return value.isNotEmpty && value != 'TO_BE_FILLED';
  }

  bool get hasDriveFileId => apkFileId.trim().isNotEmpty;

  String get changelogText => changelog.map((e) => '• $e').join('\n');
}
