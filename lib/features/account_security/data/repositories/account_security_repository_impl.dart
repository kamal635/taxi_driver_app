import 'package:taxi_driver_app/features/account_security/data/datasources/account_security_remote_data_source.dart';
import 'package:taxi_driver_app/features/account_security/domain/repositories/account_security_repository.dart';

class AccountSecurityRepositoryImpl implements AccountSecurityRepository {
  AccountSecurityRepositoryImpl(this._remoteDataSource);

  final AccountSecurityRemoteDataSource _remoteDataSource;

  @override
  Future<String> setPassword({required String newPassword}) {
    return _remoteDataSource.setPassword(newPassword: newPassword);
  }
}
