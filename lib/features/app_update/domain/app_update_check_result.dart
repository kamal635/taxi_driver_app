import 'package:taxi_driver_app/features/app_update/data/models/app_update_info.dart';
import 'package:taxi_driver_app/features/app_update/domain/update_status.dart';

/// Immutable result of an app update check.
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
