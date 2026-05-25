import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/features/auth/data/models/sign_in_response_model.dart';

/// Contract for remote authentication operations.
abstract interface class AuthRemoteDataSource {
  /// Sends the sign-in request to the backend and returns the parsed response.
  Future<SignInResponseModel> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  });
}

/// API-based implementation of [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SignInResponseModel> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final response = await _apiClient.postJson(
      '/api/auth/login',
      body: {
        'phone': phone,
        'password': password,
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      },
    );

    return SignInResponseModel.fromJson(response);
  }
}
