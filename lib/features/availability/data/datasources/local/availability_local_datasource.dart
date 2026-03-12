import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final availabilityLocalDatasourceProvider =
    Provider<AvailabilityLocalDatasource>(
      (ref) {
        return AvailabilityLocalDatasource(
          prefsFuture: SharedPreferences.getInstance(),
        );
      },
    );

final class AvailabilityLocalDatasource {
  AvailabilityLocalDatasource({
    required Future<SharedPreferences> prefsFuture,
  }) : _prefsFuture = prefsFuture;

  final Future<SharedPreferences> _prefsFuture;

  static const String _onlineRequestedKey = 'driver_online_requested';

  Future<void> saveOnlineRequested({required bool value}) async {
    final prefs = await _prefsFuture;
    await prefs.setBool(_onlineRequestedKey, value);
  }

  Future<bool> getOnlineRequested() async {
    final prefs = await _prefsFuture;
    return prefs.getBool(_onlineRequestedKey) ?? false;
  }
}
