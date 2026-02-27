import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final authSession = ref.read(authSessionProvider);
  // Main Dio instance used by the app for all API calls
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Separate Dio instance dedicated for refresh requests.
  // Important: it does NOT have the same interceptors to avoid refresh loops.
  final refreshDio = Dio(dio.options);

  // A shared "in-flight refresh" future.
  // If multiple requests fail with 401 at the same time,
  //they will all await this
  // instead of triggering multiple refresh calls.
  Future<void>? refreshing;

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      // Runs before every request is sent
      onRequest: (options, handler) {
        // Attach the current access token (if available)
        final token = authSession.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },

      // Runs when any request fails
      onError: (e, handler) async {
        final status = e.response?.statusCode;

        // Only handle 401 (Unauthorized). Other errors pass through.
        if (status != 401) {
          return handler.next(e);
        }

        // Original request that failed
        final req = e.requestOptions;

        // Prevent infinite retry loops:
        // If we already retried this request once and still got 401 -> logout.
        if (req.extra['retried'] == true) {
          await authSession.clear();
          return handler.next(e);
        }

        // If there is no refresh token, we cannot refresh -> logout.
        final rToken = authSession.refreshToken;
        if (rToken == null || rToken.isEmpty) {
          await authSession.clear();
          return handler.next(e);
        }

        try {
          // Start refresh only if it isn't already running.
          // If refresh is already running, just await it.
          refreshing ??= () async {
            // Call refresh endpoint (example path/body — depends on backend)
            final res = await refreshDio.post<dynamic>(
              '/api/auth/refresh',
              data: {
                'refreshToken': rToken,
              },
            );

            final data = res.data;

            // Parse tokens from response
            final access = (data is Map ? data['token'] : null)?.toString();

            // If server rotates refresh tokens, use the new one.
            // Otherwise, keep the old one.
            final newRefresh =
                (data is Map ? data['refreshToken'] : null)?.toString() ??
                rToken;

            // If refresh didn't return a usable access token
            //-> treat as failure.
            if (access == null || access.isEmpty) {
              throw Exception('Refresh did not return accessToken');
            }

            // Persist updated tokens in session + storage
            await authSession.updateTokens(
              token: access,
              refreshToken: newRefresh,
            );
          }();

          // Wait until refresh finishes
          await refreshing;
        } on Exception catch (_) {
          // Refresh failed -> logout
          refreshing = null;
          await authSession.clear();
          return handler.next(e);
        } finally {
          // Always reset refreshing future after completion
          refreshing = null;
        }

        try {
          // Retry the original request once with the new access token
          req.extra['retried'] = true;
          req.headers['Authorization'] = 'Bearer ${authSession.token}';

          final response = await dio.fetch<dynamic>(req);
          return handler.resolve(response);
        } on Exception catch (err) {
          // If retry fails, forward the original error
          //(or the DioException if available)
          return handler.next(err is DioException ? err : e);
        }
      },
    ),
  );

  // Add network logger only in debug mode
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
  }

  return dio;
});
