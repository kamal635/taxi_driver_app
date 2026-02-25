// lib/core/errors/failure.dart

sealed class Failure implements Exception {
  const Failure({
    required this.message,
    this.statusCode,
    this.details,
  });

  final String message;

  final int? statusCode;

  final Object? details;

  @override
  String toString() => 'Failure( statusCode: $statusCode, message: $message)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.details,
  }) : super(statusCode: null);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timeout', super.details})
    : super(statusCode: null);
}

final class CancelledFailure extends Failure {
  const CancelledFailure({super.message = 'Request cancelled', super.details})
    : super(statusCode: null);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized',
    super.statusCode,
    super.details,
  });
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Forbidden',
    super.statusCode,
    super.details,
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Not found',
    super.statusCode,
    super.details,
  });
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Invalid request',
    super.statusCode,
    super.details,
  });
}

final class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error',
    super.statusCode,
    super.details,
  });
}

final class ParsingFailure extends Failure {
  const ParsingFailure({
    super.message = 'Invalid server response',
    super.details,
  }) : super(statusCode: null);
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Something went wrong',
    super.statusCode,
    super.details,
  });
}

final class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Conflict',
    super.statusCode,
    super.details,
  });
}

final class LockedFailure extends Failure {
  const LockedFailure({
    super.message = 'Account locked',
    super.statusCode,
    super.details,
  });
}
