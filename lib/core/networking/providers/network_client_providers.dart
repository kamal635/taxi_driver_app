import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/core/networking/config/network_constants.dart';
import 'package:bawabat_al_saeq/core/networking/interceptors/auth_header_interceptor.dart';
import 'package:bawabat_al_saeq/core/networking/interceptors/session_refresh_interceptor.dart';
import 'package:bawabat_al_saeq/core/networking/refresh/session_refresh_service.dart';
import 'package:bawabat_al_saeq/core/session/session_expiration_handler.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final refreshDioProvider = Provider<Dio>((ref) {
  final dio = _createBaseDio();
  _addDebugLogger(dio);
  return dio;
});

final sessionRefreshServiceProvider = Provider<SessionRefreshService>((ref) {
  return SessionRefreshService(
    refreshDio: ref.read(refreshDioProvider),
    authSession: ref.read(authSessionProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = _createBaseDio();
  final authSession = ref.read(authSessionProvider);

  dio.interceptors
    ..add(AuthHeaderInterceptor(authSession))
    ..add(
      SessionRefreshInterceptor(
        dio: dio,
        authSession: authSession,
        sessionRefreshService: ref.read(sessionRefreshServiceProvider),
        sessionExpirationHandler: ref.read(sessionExpirationHandlerProvider),
      ),
    );

  _addDebugLogger(dio);

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(dioProvider));
});

Dio _createBaseDio() {
  return Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: NetworkConstants.defaultJsonHeaders,
    ),
  );
}

void _addDebugLogger(Dio dio) {
  if (!kDebugMode) {
    return;
  }

  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
    ),
  );
}
