import 'package:bawabat_al_saeq/core/networking/config/network_constants.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:dio/dio.dart';

class SessionRefreshService {
  SessionRefreshService({
    required Dio refreshDio,
    required AuthSession authSession,
  }) : _refreshDio = refreshDio,
       _authSession = authSession;

  final Dio _refreshDio;
  final AuthSession _authSession;

  Future<void>? _refreshInFlight;

  Future<void> refresh() {
    return _refreshInFlight ??= _refreshTokens().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _refreshTokens() async {
    final snapshot = _authSession.snapshot;
    final refreshToken = snapshot.refreshToken;

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Missing refresh token.');
    }

    final response = await _refreshDio.post<dynamic>(
      NetworkConstants.refreshEndpoint,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    final accessToken = (data is Map ? data['token'] : null)?.toString();
    final nextRefreshToken =
        (data is Map ? data['refreshToken'] : null)?.toString() ?? refreshToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Refresh did not return accessToken.');
    }

    final driverId = snapshot.driverId;
    final driverName = snapshot.driverName;
    final driverPhone = snapshot.driverPhone;

    if (driverId == null || driverId.isEmpty) {
      throw Exception('driverId is null.');
    }
    if (driverName == null || driverName.isEmpty) {
      throw Exception('driverName is null.');
    }
    if (driverPhone == null || driverPhone.isEmpty) {
      throw Exception('driverPhone is null.');
    }

    await _authSession.updateTokens(
      token: accessToken,
      refreshToken: nextRefreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
    );
  }
}
