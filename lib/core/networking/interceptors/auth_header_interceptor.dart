import 'package:bawabat_al_saeq/core/networking/config/network_constants.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:dio/dio.dart';

class AuthHeaderInterceptor extends Interceptor {
  AuthHeaderInterceptor(this._authSession);

  final AuthSession _authSession;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = _authSession.token;

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[NetworkConstants.authorizationHeader] =
          '${NetworkConstants.bearerPrefix} $accessToken';
    }

    handler.next(options);
  }
}
