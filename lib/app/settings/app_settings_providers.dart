import 'package:bawabat_al_saeq/app/settings/app_settings_controller.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_state.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final appSettingsStorageProvider = Provider<AppSettingsStorage>((ref) {
  return AppSettingsStorage();
});

final appSettingsControllerProvider =
    ChangeNotifierProvider<AppSettingsController>((ref) {
      return AppSettingsController(ref.watch(appSettingsStorageProvider));
    });

final appSettingsProvider = Provider<AppSettingsState>((ref) {
  return ref.watch(appSettingsControllerProvider).state;
});
