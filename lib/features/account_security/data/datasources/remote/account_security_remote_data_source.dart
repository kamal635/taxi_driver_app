import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/core/utils/json_reader.dart';

/// Contract for remote account-security operations.
abstract interface class AccountSecurityRemoteDataSource {
  /// Sends the new password to the backend and returns an optional response
  /// message from the server.
  Future<String?> setPassword({required String newPassword});
}

final class AccountSecurityRemoteDataSourceImpl
    implements AccountSecurityRemoteDataSource {
  const AccountSecurityRemoteDataSourceImpl(this._apiClient);

  static const String _setPasswordEndpoint =
      '/api/admin/drivers/credentials/set';

  final ApiClient _apiClient;

  @override
  Future<String?> setPassword({required String newPassword}) async {
    final response = await _apiClient.postJson(
      _setPasswordEndpoint,
      body: {'newPassword': newPassword},
    );

    return JsonReader.optionalString(response, 'message') ??
        JsonReader.optionalString(response, 'msg');
  }
}
