import 'package:bawabat_al_saeq/core/networking/config/network_constants.dart';
import 'package:bawabat_al_saeq/core/networking/refresh/forced_logout_policy.dart';
import 'package:bawabat_al_saeq/core/networking/refresh/session_refresh_service.dart';
import 'package:bawabat_al_saeq/core/session/session_expiration_handler.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:dio/dio.dart';

class SessionRefreshInterceptor extends QueuedInterceptor {
  SessionRefreshInterceptor({
    required Dio dio,
    required AuthSession authSession,
    required SessionRefreshService sessionRefreshService,
    required SessionExpirationHandler sessionExpirationHandler,
  }) : _dio = dio,
       _authSession = authSession,
       _sessionRefreshService = sessionRefreshService,
       _sessionExpirationHandler = sessionExpirationHandler;

  final Dio _dio;
  final AuthSession _authSession;
  final SessionRefreshService _sessionRefreshService;
  final SessionExpirationHandler _sessionExpirationHandler;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    if (!ForcedLogoutPolicy.shouldHandle(err)) {
      handler.next(err);
      return;
    }

    if (request.extra['retried'] == true ||
        ForcedLogoutPolicy.isRefreshRequest(request)) {
      await _handleExpiredSession();
      handler.next(err);
      return;
    }

    final refreshToken = _authSession.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await _handleExpiredSession();
      handler.next(err);
      return;
    }

    try {
      await _sessionRefreshService.refresh();
    } on Exception {
      await _handleExpiredSession();
      handler.next(err);
      return;
    }

    try {
      request.extra['retried'] = true;

      final accessToken = _authSession.token;
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers[NetworkConstants.authorizationHeader] =
            '${NetworkConstants.bearerPrefix} $accessToken';
      }

      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      if (ForcedLogoutPolicy.shouldHandle(retryError)) {
        await _handleExpiredSession();
      }

      handler.next(retryError);
    } on Exception {
      await _handleExpiredSession();
      handler.next(err);
    }
  }

  Future<void> _handleExpiredSession() {
    return _sessionExpirationHandler.handleExpiredSession();
  }
}
