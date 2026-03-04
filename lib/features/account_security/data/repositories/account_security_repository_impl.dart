import 'package:taxi_driver_app/features/account_security/data/datasources/account_security_remote_datasource.dart';
import 'package:taxi_driver_app/features/account_security/domain/repositories/account_security_repository.dart';

class AccountSecurityRepositoryImpl implements AccountSecurityRepository {
  AccountSecurityRepositoryImpl(this._remote);
  final AccountSecurityRemoteDatasource _remote;

  @override
  Future<String> setPassword({required String newPassword}) {
    return _remote.setPassword(newPassword: newPassword);
  }
}
