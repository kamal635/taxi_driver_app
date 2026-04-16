/// Failures that can happen while preparing an APK update installation.
enum AppUpdateInstallFailure {
  urlNotReady,
  invalidPackage,
  downloadFailed,
  installFailed,
}

/// Typed exception used by the update installer service.
class AppUpdateInstallerException implements Exception {
  const AppUpdateInstallerException(this.failure);

  final AppUpdateInstallFailure failure;
}
