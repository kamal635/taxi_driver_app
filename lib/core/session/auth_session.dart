import 'package:flutter/foundation.dart';
import 'package:taxi_driver_app/core/session/auth_session_storage.dart';

final class AuthSession extends ChangeNotifier {
  AuthSession(this._storage);

  final AuthSessionStorage _storage;

  String? _token;
  String? _refreshToken;
  String? _driverId;
  String? _driverName;
  String? _driverPhone;
  bool _mustChangePassword = false;
  bool _isReady = false;

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  String? get driverId => _driverId;
  String? get driverName => _driverName;
  String? get driverPhone => _driverPhone;
  bool get mustChangePassword => _mustChangePassword;
  bool get isReady => _isReady;

  bool get isLoggedIn =>
      _token != null &&
      _driverId != null &&
      _token!.isNotEmpty &&
      _driverId!.isNotEmpty;

  Future<void> load() async {
    _token = await _storage.readToken();
    _refreshToken = await _storage.readRefreshToken();
    _driverId = await _storage.readDriverId();
    _mustChangePassword = await _storage.readMustChangePassword();
    _driverName = await _storage.readDriverName();
    _driverPhone = await _storage.readDriverPhone();

    _isReady = true;
    notifyListeners();
  }

  Future<void> saveAfterLogin({
    required String token,
    required String refreshToken,
    required bool mustChangePassword,
    required String driverId,
    required String driverName,
    required String driverPhone,
  }) async {
    _token = token;
    _refreshToken = refreshToken;
    _driverId = driverId;
    _mustChangePassword = mustChangePassword;
    _driverPhone = driverPhone;
    _driverName = driverName;

    await _storage.save(
      token: token,
      refreshToken: refreshToken,
      driverId: driverId,
      mustChangePassword: mustChangePassword,
      driverPhone: driverPhone,
      driverName: driverName,
    );

    notifyListeners();
  }

  Future<void> markPasswordCreated() async {
    _mustChangePassword = false;
    await _storage.writeMustChangePassword(value: false);
    notifyListeners();
  }

  Future<void> updateTokens({
    required String token,
    required String refreshToken,
    required String driverId,
    required String driverName,
    required String driverPhone,
  }) async {
    _token = token;
    _refreshToken = refreshToken;
    _driverId = driverId;
    _driverName = driverName;
    _driverPhone = driverPhone;

    await _storage.save(
      token: token,
      refreshToken: refreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      mustChangePassword: _mustChangePassword,
    );

    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    _refreshToken = null;
    _driverId = null;
    _driverName = null;
    _driverPhone = null;
    _mustChangePassword = false;

    await _storage.clear();

    notifyListeners();
  }
}
