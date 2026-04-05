import 'package:shared_preferences/shared_preferences.dart';

/// Persists the driver's local availability intent.
///
/// This value is used only to restore or reconcile UI/runtime state.
final class AvailabilityLocalDataSource {
  AvailabilityLocalDataSource({
    required Future<SharedPreferences> preferencesFuture,
  }) : _preferencesFuture = preferencesFuture;

  final Future<SharedPreferences> _preferencesFuture;

  static const String _onlineRequestedKey = 'driver_online_requested';

  Future<void> saveOnlineRequested({required bool value}) async {
    final preferences = await _preferencesFuture;
    await preferences.setBool(_onlineRequestedKey, value);
  }

  Future<bool> getOnlineRequested() async {
    final preferences = await _preferencesFuture;
    return preferences.getBool(_onlineRequestedKey) ?? false;
  }
}
