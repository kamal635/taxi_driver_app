import 'package:dio/dio.dart';
import 'package:taxi_driver_app/core/networking/config/network_constants.dart';

final class ForcedLogoutPolicy {
  const ForcedLogoutPolicy._();

  static bool shouldHandle(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    final message = responseData is Map
        ? (responseData['message'] ??
                  responseData['error'] ??
                  responseData['detail'])
              ?.toString()
        : null;

    final normalized = message?.toLowerCase();

    if (statusCode == 401 || statusCode == 423) {
      return true;
    }

    if (normalized == null) {
      return false;
    }

    return normalized.contains('must_change_password') ||
        normalized.contains('must change password') ||
        normalized.contains('password reset required') ||
        normalized.contains('reauth') ||
        normalized.contains('deleted') ||
        normalized.contains('disabled') ||
        normalized.contains('inactive') ||
        normalized.contains('blocked') ||
        normalized.contains('revoked');
  }

  static bool isRefreshRequest(RequestOptions request) {
    return request.path == NetworkConstants.refreshEndpoint;
  }
}
