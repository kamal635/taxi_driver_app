import 'package:dio/dio.dart';
import 'package:taxi_driver_app/core/networking/config/network_constants.dart';
import 'package:taxi_driver_app/core/session/session_store.dart';

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
