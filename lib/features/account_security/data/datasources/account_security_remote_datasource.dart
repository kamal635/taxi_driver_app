import 'package:taxi_driver_app/core/networking/api_client.dart';

abstract class AccountSecurityRemoteDatasource {
  Future<String> setPassword({required String newPassword});
}

class AccountSecurityRemoteDatasourceImpl
    implements AccountSecurityRemoteDatasource {
  AccountSecurityRemoteDatasourceImpl(this._api);
  final ApiClient _api;

  @override
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
