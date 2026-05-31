import 'package:bawabat_al_saeq/features/account_security/data/datasources/remote/account_security_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/account_security/domain/repositories/account_security_repository.dart';

final class AccountSecurityRepositoryImpl implements AccountSecurityRepository {
  const AccountSecurityRepositoryImpl(this._remoteDataSource);

  final AccountSecurityRemoteDataSource _remoteDataSource;

  @override
  Future<String?> setPassword({required String newPassword}) {
    return _remoteDataSource.setPassword(newPassword: newPassword);
  }
}
