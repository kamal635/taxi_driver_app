import 'package:dio/dio.dart';

abstract final class OfferStaleErrorResolver {
  static bool isStaleOfferError(Object error) {
    final statusCode = _tryReadStatusCode(error);

    if (statusCode == 404 || statusCode == 409) {
      return true;
    }

    final responseData = _tryReadResponseData(error);

    if (_containsStaleOfferSignal(responseData)) {
      return true;
    }

    return _containsStaleOfferSignal(error.toString());
  }

  static int? _tryReadStatusCode(Object error) {
    if (error is DioException) {
      return error.response?.statusCode;
    }

    return null;
  }

  static Object? _tryReadResponseData(Object error) {
    if (error is DioException) {
      return error.response?.data;
    }

    return null;
  }

  static bool _containsStaleOfferSignal(Object? value) {
    if (value == null) return false;

    final text = value.toString().toLowerCase();

    return text.contains('expired') ||
        text.contains('invalid') ||
        text.contains('not found') ||
        text.contains('no longer available') ||
        text.contains('already accepted') ||
        text.contains('already rejected') ||
        text.contains('offer expired') ||
        text.contains('offer invalid');
  }
}
