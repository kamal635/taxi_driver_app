import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AuthSessionStorage {
  AuthSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kDriverId = 'driver_id';
  static const _kMustChangePassword = 'must_change_password';

  final FlutterSecureStorage _storage;

  Future<String?> readToken() async {
    return _storage.read(key: _kAccessToken);
  }

  Future<String?> readRefreshToken() async {
    return _storage.read(key: _kRefreshToken);
  }

  Future<String?> readDriverId() async {
    return _storage.read(key: _kDriverId);
  }

  Future<bool> readMustChangePassword() async {
    final raw = await _storage.read(key: _kMustChangePassword);
    return raw == 'true';
  }

  Future<void> writeMustChangePassword({required bool value}) async {
    await _storage.write(
      key: _kMustChangePassword,
      value: value.toString(),
    );
  }

  Future<void> save({
    required String token,
    required String refreshToken,
    required String driverId,
    required bool mustChangePassword,
  }) async {
    await _storage.write(key: _kAccessToken, value: token);
    await _storage.write(key: _kRefreshToken, value: refreshToken);
    await _storage.write(key: _kDriverId, value: driverId);
    await _storage.write(
      key: _kMustChangePassword,
      value: mustChangePassword.toString(),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _kAccessToken),
      _storage.delete(key: _kRefreshToken),
      _storage.delete(key: _kDriverId),
      _storage.delete(key: _kMustChangePassword),
    ]);
  }
}
