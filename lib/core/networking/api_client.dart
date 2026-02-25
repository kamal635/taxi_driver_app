import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/core/networking/dio_exception_mapper.dart';
import 'package:taxi_driver_app/core/networking/dio_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(dioProvider));
});

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );

      final data = res.data;
      if (data == null) {
        throw const ParsingFailure(message: 'Empty response body');
      }
      return data;
    } on DioException catch (e) {
      throw mapDioException(e);
    } on FormatException catch (e) {
      throw ParsingFailure(details: e);
    }
  }

  Future<void> postVoid(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      await _dio.post<void>(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
