import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:dio/dio.dart';

Failure mapDioException(DioException exception) {
  if (_isTimeout(exception.type)) {
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

  return switch (statusCode) {
    400 => ValidationFailure(
      message: serverMessage ?? 'Missing/invalid data',
      statusCode: statusCode,
      details: responseData,
    ),
    401 => UnauthorizedFailure(
      message: serverMessage ?? 'JWT invalid or expired',
      statusCode: statusCode,
      details: responseData,
    ),
    403 => ForbiddenFailure(
      message: serverMessage ?? 'Forbidden',
      statusCode: statusCode,
      details: responseData,
    ),
    404 => NotFoundFailure(
      message: serverMessage ?? 'Not found',
      statusCode: statusCode,
      details: responseData,
    ),
    409 => ConflictFailure(
      message: serverMessage ?? 'Conflict',
      statusCode: statusCode,
      details: responseData,
    ),
    423 => LockedFailure(
      message: serverMessage ?? 'Account locked',
      statusCode: statusCode,
      details: responseData,
    ),
    final code? when code >= 500 => ServerFailure(
      message: serverMessage ?? 'Server error',
      statusCode: code,
      details: responseData,
    ),
    final code? when code >= 400 => ValidationFailure(
      message: serverMessage ?? 'Invalid request',
      statusCode: code,
      details: responseData,
    ),
    _ => UnknownFailure(
      message: serverMessage ?? exception.message ?? 'Unknown error',
      statusCode: statusCode,
      details: responseData,
    ),
  };
}

bool _isTimeout(DioExceptionType type) {
  return type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout;
}

String? _extractServerMessage(Object? data) {
  if (data == null) return null;

  if (data is String) {
    final message = data.trim();
    return message.isEmpty ? null : message;
  }

  if (data is! Map) return null;

  final map = data.cast<String, dynamic>();

  for (final key in const ['message', 'error', 'detail']) {
    final message = _stringFromValue(map[key]);
    if (message != null) return message;
  }

  final validationErrors = map['errors'];
  final firstValidationMessage = _firstValidationMessage(validationErrors);
  if (firstValidationMessage != null) return firstValidationMessage;

  return null;
}

String? _firstValidationMessage(Object? value) {
  if (value is List && value.isNotEmpty) {
    return _stringFromValue(value.first);
  }

  if (value is Map && value.isNotEmpty) {
    final firstValue = value.values.first;
    if (firstValue is List && firstValue.isNotEmpty) {
      return _stringFromValue(firstValue.first);
    }

    return _stringFromValue(firstValue);
  }

  return _stringFromValue(value);
}

String? _stringFromValue(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}
