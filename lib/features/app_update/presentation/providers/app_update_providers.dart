import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/app_update/data/services/apk_install_service.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_installer_service.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/presentation/controllers/app_update_flow_controller.dart';
import 'package:taxi_driver_app/features/app_update/presentation/controllers/app_update_status_controller.dart';

final appUpdateDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );
});

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService(ref.read(appUpdateDioProvider));
});

final apkInstallServiceProvider = Provider<ApkInstallService>((ref) {
  return ApkInstallService();
});

final appUpdateInstallerServiceProvider = Provider<AppUpdateInstallerService>(
  (ref) {
    return AppUpdateInstallerService(
      ref.read(appUpdateServiceProvider),
      ref.read(apkInstallServiceProvider),
    );
  },
);

final appUpdateStatusProvider =
    AsyncNotifierProvider<AppUpdateStatusController, AppUpdateCheckResult>(
      AppUpdateStatusController.new,
    );

final appUpdateFlowControllerProvider =
    NotifierProvider<AppUpdateFlowController, AppUpdateFlowState>(
      AppUpdateFlowController.new,
    );
