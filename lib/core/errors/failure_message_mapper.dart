import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

enum FailureContext {
  general,
  authLogin,
}

/// Maps a Failure/Exception to a localized, user-friendly message.
String failureToUserMessage(
  Object error, {
  required AppLocalizations l10n,
  FailureContext context = FailureContext.general,
}) {
  if (error is! Failure) {
    return l10n.errorUnexpected;
  }

  switch (error) {
    case NetworkFailure():
      return l10n.errorNoInternet;
    case TimeoutFailure():
      return l10n.errorTimeout;
    case CancelledFailure():
      return l10n.errorCancelled;
    case LockedFailure():
      return l10n.errorAccountLocked;
    case ConflictFailure():
      return l10n.errorConflict;
    case ValidationFailure():
      return l10n.errorValidation;
    case NotFoundFailure():
      return l10n.errorNotFound;
    case ForbiddenFailure():
      return l10n.errorForbidden;
    case UnauthorizedFailure():
      if (context == FailureContext.authLogin) {
        return l10n.errorInvalidCredentials;
      }
      return l10n.errorSessionExpired;
    case ServerFailure():
      return l10n.errorServer;
    case ParsingFailure():
      return l10n.errorBadResponse;
    case UnknownFailure():
      return l10n.errorUnexpected;
  }
}
