import 'package:bawabat_al_saeq/core/networking/api_client.dart';

/// Contract for remote account security operations.
abstract class AccountSecurityRemoteDataSource {
  /// Sends the new password to the backend and returns the response message.
  Future<String> setPassword({required String newPassword});
}

class AccountSecurityRemoteDataSourceImpl
    implements AccountSecurityRemoteDataSource {
  AccountSecurityRemoteDataSourceImpl(this._apiClient);

  static const String _setPasswordEndpoint =
      '/api/admin/drivers/credentials/set';

  final ApiClient _apiClient;

  @override
  Future<String> setPassword({required String newPassword}) async {
    final response = await _apiClient.postJson(
      _setPasswordEndpoint,
      body: {'newPassword': newPassword},
    );

    return (response['message'] as String?) ?? '';
  }
}
