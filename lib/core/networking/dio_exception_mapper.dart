import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:dio/dio.dart';

Failure mapDioException(DioException exception) {
  if (exception.type == DioExceptionType.connectionTimeout ||
      exception.type == DioExceptionType.sendTimeout ||
      exception.type == DioExceptionType.receiveTimeout) {
    return TimeoutFailure(details: exception);
  }

  if (exception.type == DioExceptionType.cancel) {
    return CancelledFailure(details: exception);
  }

  if (exception.type == DioExceptionType.connectionError) {
    return NetworkFailure(details: exception);
  }

  final statusCode = exception.response?.statusCode;
  final responseData = exception.response?.data;
  final serverMessage = _extractServerMessage(responseData);

  if (statusCode == 400) {
    return ValidationFailure(
      message: serverMessage ?? 'Missing/invalid data',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode == 401) {
    return UnauthorizedFailure(
      message: serverMessage ?? 'JWT invalid or expired',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode == 409) {
    return ConflictFailure(
      message: serverMessage ?? 'Conflict',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode == 423) {
    return LockedFailure(
      message: serverMessage ?? 'Account locked',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode == 403) {
    return ForbiddenFailure(
      message: serverMessage ?? 'Forbidden',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode == 404) {
    return NotFoundFailure(
      message: serverMessage ?? 'Not found',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(
      message: serverMessage ?? 'Server error',
      statusCode: statusCode,
      details: responseData,
    );
  }

  if (statusCode != null && statusCode >= 400 && statusCode < 500) {
    return ValidationFailure(
      message: serverMessage ?? 'Invalid request',
      statusCode: statusCode,
      details: responseData,
    );
  }

  return UnknownFailure(
    message: serverMessage ?? (exception.message ?? 'Unknown error'),
    statusCode: statusCode,
    details: responseData,
  );
}

String? _extractServerMessage(Object? data) {
  if (data is! Map) return null;

  final map = data.cast<String, dynamic>();
  return (map['message'] ?? map['error'] ?? map['detail'])?.toString();
}
