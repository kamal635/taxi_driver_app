import 'package:flutter/foundation.dart';
import 'package:taxi_driver_app/core/session/auth_session_storage.dart';

final class AuthSession extends ChangeNotifier {
  AuthSession(this._storage);

  final AuthSessionStorage _storage;

  String? _token;
  String? _refreshToken;
  bool _mustChangePassword = false;
  bool _isReady = false;

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  bool get mustChangePassword => _mustChangePassword;
  bool get isReady => _isReady;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> load() async {
    _token = await _storage.readToken();
    _refreshToken = await _storage.readRefreshToken();
    _mustChangePassword = await _storage.readMustChangePassword();

    _isReady = true;
    notifyListeners();
  }

  Future<void> saveAfterLogin({
    required String token,
    required String refreshToken,
    required bool mustChangePassword,
  }) async {
    _token = token;
    _refreshToken = refreshToken;
    _mustChangePassword = mustChangePassword;

    await _storage.save(
      token: token,
      refreshToken: refreshToken,
      mustChangePassword: mustChangePassword,
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
  }) async {
    _token = token;
    _refreshToken = refreshToken;

    await _storage.save(
      token: token,
      refreshToken: refreshToken,
      mustChangePassword: _mustChangePassword,
    );

    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    _refreshToken = null;
    _mustChangePassword = false;

    await _storage.clear();

    notifyListeners();
  }
}
