import 'package:bawabat_al_saeq/core/session/auth_session_storage.dart';
import 'package:bawabat_al_saeq/core/session/models/auth_session_snapshot.dart';
import 'package:flutter/foundation.dart';

final class AuthSession extends ChangeNotifier {
  AuthSession(this._storage);

  final AuthSessionStorage _storage;

  AuthSessionSnapshot _snapshot = const AuthSessionSnapshot.empty();

  AuthSessionSnapshot get snapshot => _snapshot;

  String? get token => _snapshot.token;
  String? get refreshToken => _snapshot.refreshToken;
  String? get driverId => _snapshot.driverId;
  String? get driverName => _snapshot.driverName;
  String? get driverPhone => _snapshot.driverPhone;
  bool get mustChangePassword => _snapshot.mustChangePassword;
  bool get isReady => _snapshot.isReady;
  bool get isLoggedIn => _snapshot.isLoggedIn;

  Future<void> load() async {
    _setSnapshot(
      AuthSessionSnapshot(
        token: await _storage.readToken(),
        refreshToken: await _storage.readRefreshToken(),
        driverId: await _storage.readDriverId(),
        driverName: await _storage.readDriverName(),
        driverPhone: await _storage.readDriverPhone(),
        mustChangePassword: await _storage.readMustChangePassword(),
        isReady: true,
      ),
    );
  }

  Future<void> saveAfterLogin({
    required String token,
    required String refreshToken,
    required bool mustChangePassword,
    required String driverId,
    required String driverName,
    required String driverPhone,
  }) async {
    final nextSnapshot = _snapshot.copyWith(
      token: token,
      refreshToken: refreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      mustChangePassword: mustChangePassword,
      isReady: true,
    );

    await _persist(nextSnapshot);
    _setSnapshot(nextSnapshot);
  }

  Future<void> markPasswordCreated() async {
    final nextSnapshot = _snapshot.copyWith(
      mustChangePassword: false,
    );

    await _storage.writeMustChangePassword(value: false);
    _setSnapshot(nextSnapshot);
  }

  Future<void> updateTokens({
    required String token,
    required String refreshToken,
    required String driverId,
    required String driverName,
    required String driverPhone,
  }) async {
    final nextSnapshot = _snapshot.copyWith(
      token: token,
      refreshToken: refreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
    );

    await _persist(nextSnapshot);
    _setSnapshot(nextSnapshot);
  }

  Future<void> clear() async {
    final clearedSnapshot = _snapshot.copyWith(
      mustChangePassword: false,
      clearToken: true,
      clearRefreshToken: true,
      clearDriverId: true,
      clearDriverName: true,
      clearDriverPhone: true,
      isReady: true,
    );

    await _storage.clear();
    _setSnapshot(clearedSnapshot);
  }

  Future<void> _persist(AuthSessionSnapshot snapshot) {
    return _storage.save(
      token: snapshot.token ?? '',
      refreshToken: snapshot.refreshToken ?? '',
      driverId: snapshot.driverId ?? '',
      driverName: snapshot.driverName ?? '',
      driverPhone: snapshot.driverPhone ?? '',
      mustChangePassword: snapshot.mustChangePassword,
    );
  }

  void _setSnapshot(AuthSessionSnapshot snapshot) {
    _snapshot = snapshot;
    notifyListeners();
  }
}
