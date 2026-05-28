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
    final values = await Future.wait<Object?>([
      _storage.readToken(),
      _storage.readRefreshToken(),
      _storage.readDriverId(),
      _storage.readDriverName(),
      _storage.readDriverPhone(),
      _storage.readMustChangePassword(),
    ]);

    _setSnapshot(
      AuthSessionSnapshot(
        token: values[0] as String?,
        refreshToken: values[1] as String?,
        driverId: values[2] as String?,
        driverName: values[3] as String?,
        driverPhone: values[4] as String?,
        mustChangePassword: values[5]! as bool,
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
    final nextSnapshot = _snapshot.copyWith(mustChangePassword: false);

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
    const clearedSnapshot = AuthSessionSnapshot.readyUnauthenticated();

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
    if (_snapshot == snapshot) return;

    _snapshot = snapshot;
    notifyListeners();
  }
}
