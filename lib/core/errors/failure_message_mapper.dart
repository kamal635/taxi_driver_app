import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

enum FailureContext {
  general,
  authLogin,
}

/// Maps a technical error to a localized user-facing message.
String failureToUserMessage(
  Object error, {
  required AppLocalizations l10n,
  FailureContext context = FailureContext.general,
}) {
  if (error is! Failure) {
    return l10n.errorUnexpected;
  }

  return switch (error) {
    NetworkFailure() => l10n.errorNoInternet,
    TimeoutFailure() => l10n.errorTimeout,
    CancelledFailure() => l10n.errorCancelled,
    LockedFailure() => l10n.errorAccountLocked,
    ConflictFailure() => l10n.errorConflict,
    ValidationFailure() => l10n.errorValidation,
    NotFoundFailure() => l10n.errorNotFound,
    ForbiddenFailure() => l10n.errorForbidden,
    UnauthorizedFailure() => context == FailureContext.authLogin
        ? l10n.errorInvalidCredentials
        : l10n.errorSessionExpired,
    ServerFailure() => l10n.errorServer,
    ParsingFailure() => l10n.errorBadResponse,
    UnknownFailure() => l10n.errorUnexpected,
  };
}
