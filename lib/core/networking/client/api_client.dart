import 'package:dio/dio.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/core/networking/dio_exception_mapper.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeJsonRequest(
      () => _dio.post<Map<String, dynamic>>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<void> postVoid(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeVoidRequest(
      () => _dio.post<void>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeJsonRequest(
      () => _dio.put<Map<String, dynamic>>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<void> putVoid(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeVoidRequest(
      () => _dio.put<void>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeJsonRequest(
      () => _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<void> getVoid(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    return _executeVoidRequest(
      () => _dio.get<void>(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Map<String, dynamic>> _executeJsonRequest(
    Future<Response<Map<String, dynamic>>> Function() request,
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
    }
  }

  Future<void> _executeVoidRequest(
    Future<Response<void>> Function() request,
  ) async {
    try {
      await request();
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }
}
