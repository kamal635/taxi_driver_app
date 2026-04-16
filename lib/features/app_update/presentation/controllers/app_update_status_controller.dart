import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/app_update/domain/app_update_check_result.dart';
import 'package:taxi_driver_app/features/app_update/domain/update_status.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';

/// Loads and refreshes the remote update status.
class AppUpdateStatusController extends AsyncNotifier<AppUpdateCheckResult> {
  @override
  Future<AppUpdateCheckResult> build() {
    return ref.read(appUpdateServiceProvider).checkForUpdate();
  }

  Future<AppUpdateCheckResult> refreshStatus() async {
    state = const AsyncLoading();

    final nextState = await AsyncValue.guard(
      () => ref.read(appUpdateServiceProvider).checkForUpdate(),
    );

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
