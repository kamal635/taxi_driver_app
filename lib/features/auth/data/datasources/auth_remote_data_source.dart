import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/auth/data/models/sign_in_response_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(apiClientProvider));
});

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._api);

  final ApiClient _api;

  Future<SignInResponseModel> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final data = await _api.postJson(
      '/api/auth/login',
      body: {
        'phone': phone,
        'password': password,
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      },
    );

    return SignInResponseModel.fromJson(data);
  }

  Future<String> setPassword({
    required String newPassword,
  }) async {
    final data = await _api.postJson(
      '/api/admin/drivers/credentials/set',
      body: {'newPassword': newPassword},
    );

    return (data['message'] as String?) ?? '';
  }
}
