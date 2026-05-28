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
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);

  static const String _loginPath = '/api/auth/login';

  final ApiClient _apiClient;

  @override
  Future<SignInResponseModel> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final normalizedPhone = phone.trim();
    final normalizedFcmToken = fcmToken?.trim();

    final response = await _apiClient.postJson(
      _loginPath,
      body: {
        'phone': normalizedPhone,
        'password': password,
        if (normalizedFcmToken != null && normalizedFcmToken.isNotEmpty)
          'fcmToken': normalizedFcmToken,
      },
    );

    return SignInResponseModel.fromJson(response);
  }
}
