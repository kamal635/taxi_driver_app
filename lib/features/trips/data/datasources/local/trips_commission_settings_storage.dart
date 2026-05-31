import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores local preferences related to the trips commission calculator.
class TripsCommissionSettingsStorage {
  const TripsCommissionSettingsStorage(this._storage);

  static const _commissionPercentageKey = 'trips_commission_percentage';

  final FlutterSecureStorage _storage;

  Future<String?> readCommissionPercentageText() {
    return _storage.read(key: _commissionPercentageKey);
  }

  Future<void> saveCommissionPercentageText(String value) {
    return _storage.write(
      key: _commissionPercentageKey,
      value: value,
    );
  }
}
