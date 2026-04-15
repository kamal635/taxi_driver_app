import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/app_update/data/services/app_update_service.dart';
import 'package:taxi_driver_app/features/app_update/domain/update_status.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';

class AppUpdateStatusController extends AsyncNotifier<AppUpdateCheckResult> {
  AppUpdateService get _service => ref.read(appUpdateServiceProvider);

  @override
  Future<AppUpdateCheckResult> build() {
    return _service.checkForUpdate();
  }

  Future<AppUpdateCheckResult> refreshStatus() async {
    state = const AsyncLoading();

    final nextState = await AsyncValue.guard(_service.checkForUpdate);
    state = nextState;

    return nextState.value ??
        const AppUpdateCheckResult(
          status: UpdateStatus.noUpdate,
          info: null,
          currentVersionCode: 0,
          currentVersionName: '',
        );
  }
}
