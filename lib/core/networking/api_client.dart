import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/core/networking/dio_exception_mapper.dart';
import 'package:dio/dio.dart';

typedef JsonMap = Map<String, dynamic>;

/// Small Dio wrapper that normalizes API errors into app [Failure] objects.
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<JsonMap> getJson(
    String path, {
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeJsonRequest(
      () => _dio.get<JsonMap>(
        path,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<void> getVoid(
    String path, {
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeVoidRequest(
      () => _dio.get<void>(
        path,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<JsonMap> postJson(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeJsonRequest(
      () => _dio.post<JsonMap>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<void> postVoid(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeVoidRequest(
      () => _dio.post<void>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<JsonMap> putJson(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeJsonRequest(
      () => _dio.put<JsonMap>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<void> putVoid(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeVoidRequest(
      () => _dio.put<void>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<JsonMap> patchJson(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeJsonRequest(
      () => _dio.patch<JsonMap>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<void> patchVoid(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeVoidRequest(
      () => _dio.patch<void>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<JsonMap> deleteJson(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeJsonRequest(
      () => _dio.delete<JsonMap>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Future<void> deleteVoid(
    String path, {
    JsonMap? body,
    JsonMap? headers,
    JsonMap? query,
  }) {
    return _executeVoidRequest(
      () => _dio.delete<void>(
        path,
        data: body,
        queryParameters: query,
        options: _options(headers),
      ),
    );
  }

  Options? _options(JsonMap? headers) {
    if (headers == null || headers.isEmpty) {
      return null;
    }

    return Options(headers: headers);
  }

  Future<JsonMap> _executeJsonRequest(
    Future<Response<JsonMap>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;

      if (data == null) {
        throw const ParsingFailure(message: 'Empty response body');
      }

      return data;
    } on DioException catch (error) {
      throw mapDioException(error);
    } on FormatException catch (error) {
      throw ParsingFailure(details: error);
    } on Failure {
      rethrow;
    } catch (error) {
      throw ParsingFailure(details: error);
    }
  }

  Future<void> _executeVoidRequest(
    Future<Response<void>> Function() request,
  ) async {
    try {
      await request();
    } on DioException catch (error) {
      throw mapDioException(error);
    } on Failure {
      rethrow;
    } catch (error) {
      throw ParsingFailure(details: error);
    }
  }
}
