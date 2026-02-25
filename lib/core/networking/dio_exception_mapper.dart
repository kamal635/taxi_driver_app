import 'package:dio/dio.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';

Failure mapDioException(DioException e) {
  // timeouts
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return TimeoutFailure(details: e);
  }

  // cancelled
  if (e.type == DioExceptionType.cancel) {
    return CancelledFailure(details: e);
  }

  // network
  if (e.type == DioExceptionType.connectionError) {
    return NetworkFailure(details: e);
  }

  // response-based
  final status = e.response?.statusCode;
  final data = e.response?.data;

  String? serverMessage;

  if (data is Map) {
    final map = data.cast<String, dynamic>();
    serverMessage = (map['message'] ?? map['error'] ?? map['detail'])
        ?.toString();
  }

  if (status == 400) {
    return ValidationFailure(
      message: serverMessage ?? 'Missing/invalid data',
      statusCode: status,
      details: data,
    );
  }

  if (status == 401) {
    return UnauthorizedFailure(
      message: serverMessage ?? 'JWT invalid or expired',
      statusCode: status,
      details: data,
    );
  }

  if (status == 409) {
    return ConflictFailure(
      message: serverMessage ?? 'Conflict',
      statusCode: status,
      details: data,
    );
  }

  if (status == 423) {
    return LockedFailure(
      message: serverMessage ?? 'Account locked',
      statusCode: status,
      details: data,
    );
  }

  if (status == 403) {
    return ForbiddenFailure(
      message: serverMessage ?? 'Forbidden',
      statusCode: status,
      details: data,
    );
  }

  if (status == 404) {
    return NotFoundFailure(
      message: serverMessage ?? 'Not found',
      statusCode: status,
      details: data,
    );
  }

  if (status != null && status >= 500) {
    return ServerFailure(
      message: serverMessage ?? 'Server error',
      statusCode: status,
      details: data,
    );
  }

  if (status != null && status >= 400 && status < 500) {
    return ValidationFailure(
      message: serverMessage ?? 'Invalid request',
      statusCode: status,
      details: data,
    );
  }

  return UnknownFailure(
    message: serverMessage ?? (e.message ?? 'Unknown error'),
    statusCode: status,
    details: data,
  );
}
