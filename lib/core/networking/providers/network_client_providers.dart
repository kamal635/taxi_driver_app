import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/core/networking/config/network_constants.dart';
import 'package:taxi_driver_app/core/networking/interceptors/auth_header_interceptor.dart';
import 'package:taxi_driver_app/core/networking/interceptors/session_refresh_interceptor.dart';
import 'package:taxi_driver_app/core/networking/refresh/session_refresh_service.dart';
import 'package:taxi_driver_app/core/session/app_sign_out_service.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';

final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: NetworkConstants.defaultJsonHeaders,
    ),
  );
});

final sessionRefreshServiceProvider = Provider<SessionRefreshService>((ref) {
  return SessionRefreshService(
    refreshDio: ref.read(refreshDioProvider),
    authSession: ref.read(authSessionProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: NetworkConstants.defaultJsonHeaders,
    ),
  );

  dio.interceptors.add(
    AuthHeaderInterceptor(ref.read(authSessionProvider)),
  );

  dio.interceptors.add(
    SessionRefreshInterceptor(
      dio: dio,
      authSession: ref.read(authSessionProvider),
      sessionRefreshService: ref.read(sessionRefreshServiceProvider),
      appSignOutService: ref.read(appSignOutServiceProvider),
    ),
  );

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(dioProvider));
});
