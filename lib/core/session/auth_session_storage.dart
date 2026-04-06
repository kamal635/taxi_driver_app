import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AuthSessionStorage {
  AuthSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _driverIdKey = 'driver_id';
  static const _driverPhoneKey = 'driver_phone';
  static const _driverNameKey = 'driver_name';
  static const _mustChangePasswordKey = 'must_change_password';

  final FlutterSecureStorage _storage;

  Future<String?> readToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<String?> readDriverId() {
    return _storage.read(key: _driverIdKey);
  }

  Future<String?> readDriverPhone() {
    return _storage.read(key: _driverPhoneKey);
  }

  Future<String?> readDriverName() {
    return _storage.read(key: _driverNameKey);
  }

  Future<bool> readMustChangePassword() async {
    final raw = await _storage.read(key: _mustChangePasswordKey);
    return raw == 'true';
  }

  Future<void> writeMustChangePassword({required bool value}) {
    return _storage.write(
      key: _mustChangePasswordKey,
      value: value.toString(),
    );
  }

  Future<void> save({
    required String token,
    required String refreshToken,
    required String driverId,
    required String driverPhone,
    required String driverName,
    required bool mustChangePassword,
  }) async {
    await _storage.write(key: _accessTokenKey, value: token);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _driverIdKey, value: driverId);
    await _storage.write(key: _driverPhoneKey, value: driverPhone);
    await _storage.write(key: _driverNameKey, value: driverName);
    await _storage.write(
      key: _mustChangePasswordKey,
      value: mustChangePassword.toString(),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _driverIdKey),
      _storage.delete(key: _driverPhoneKey),
      _storage.delete(key: _driverNameKey),
      _storage.delete(key: _mustChangePasswordKey),
    ]);
  }
}
