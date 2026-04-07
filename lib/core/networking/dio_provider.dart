import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/app_sign_out_service.dart';
import 'package:taxi_driver_app/core/session/auth_session.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final authSession = ref.read(authSessionProvider);
  final appSignOutService = ref.read(appSignOutServiceProvider);

  Future<void> forceLocalSignOut() {
    return appSignOutService.signOut(notifyBackend: false);
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://taxi-backend.laithroom.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final refreshDio = Dio(dio.options);
  Future<void>? refreshInFlight;

  bool isForcedLogoutStatus(DioException error) {
    final status = error.response?.statusCode;

    if (status == 401) return true;

    if (status == 403) {
      final data = error.response?.data;
      final message = data is Map
          ? (data['message'] ?? data['error'] ?? data['detail'])?.toString()
          : null;

      if (message != null) {
        final normalized = message.toLowerCase();
        if (normalized.contains('deleted') ||
            normalized.contains('disabled') ||
            normalized.contains('inactive') ||
            normalized.contains('blocked') ||
            normalized.contains('revoked')) {
          return true;
        }
      }
    }

    return false;
  }

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        final token = authSession.token;

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        final request = error.requestOptions;

        if (!isForcedLogoutStatus(error)) {
          return handler.next(error);
        }

        // لو نفس الطلب رجع مرة ثانية بعد retry → اخرج
        if (request.extra['retried'] == true) {
          await forceLocalSignOut();
          return handler.next(error);
        }

        // لا تحاول refresh على refresh endpoint نفسه
        if (request.path == '/api/auth/refresh') {
          await forceLocalSignOut();
          return handler.next(error);
        }

        final refreshToken = authSession.refreshToken;
        if (refreshToken == null || refreshToken.isEmpty) {
          await forceLocalSignOut();
          return handler.next(error);
        }

        try {
          refreshInFlight ??= _refreshSession(
            refreshDio: refreshDio,
            authSession: authSession,
            refreshToken: refreshToken,
          );

          await refreshInFlight;
        } on Exception {
          await forceLocalSignOut();
          return handler.next(error);
        } finally {
          refreshInFlight = null;
        }

        try {
          request.extra['retried'] = true;
          request.headers['Authorization'] = 'Bearer ${authSession.token}';

          final response = await dio.fetch<dynamic>(request);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          if (isForcedLogoutStatus(retryError)) {
            await forceLocalSignOut();
          }
          return handler.next(retryError);
        } on Exception {
          await forceLocalSignOut();
          return handler.next(error);
        }
      },
    ),
  );

  return dio;
});

Future<void> _refreshSession({
  required Dio refreshDio,
  required AuthSession authSession,
  required String refreshToken,
}) async {
  final response = await refreshDio.post<dynamic>(
    '/api/auth/refresh',
    data: {
      'refreshToken': refreshToken,
    },
  );

  final data = response.data;
  final driverId = authSession.driverId;
  final driverName = authSession.driverName;
  final driverPhone = authSession.driverPhone;

  final accessToken = (data is Map ? data['token'] : null)?.toString();
  final nextRefreshToken =
      (data is Map ? data['refreshToken'] : null)?.toString() ?? refreshToken;

  if (accessToken == null || accessToken.isEmpty) {
    throw Exception('Refresh did not return accessToken');
  }

  if (driverId == null || driverId.isEmpty) {
    throw Exception('driverId is null');
  }

  if (driverName == null || driverName.isEmpty) {
    throw Exception('driverName is null');
  }

  if (driverPhone == null || driverPhone.isEmpty) {
    throw Exception('driverPhone is null');
  }

  await authSession.updateTokens(
    driverName: driverName,
    driverPhone: driverPhone,
    driverId: driverId,
    token: accessToken,
    refreshToken: nextRefreshToken,
  );
}
