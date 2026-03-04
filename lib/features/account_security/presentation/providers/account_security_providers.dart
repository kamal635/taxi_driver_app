import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/account_security/data/datasources/account_security_remote_datasource.dart';
import 'package:taxi_driver_app/features/account_security/data/repositories/account_security_repository_impl.dart';
import 'package:taxi_driver_app/features/account_security/domain/repositories/account_security_repository.dart';
import 'package:taxi_driver_app/features/account_security/domain/usecases/set_password_usecase.dart';

final accountSecurityRemoteDatasourceProvider =
    Provider<AccountSecurityRemoteDatasource>((ref) {
      return AccountSecurityRemoteDatasourceImpl(ref.read(apiClientProvider));
    });

final accountSecurityRepositoryProvider = Provider<AccountSecurityRepository>((
  ref,
) {
  return AccountSecurityRepositoryImpl(
    ref.read(accountSecurityRemoteDatasourceProvider),
  );
});

final setPasswordUseCaseProvider = Provider<SetPasswordUseCase>((ref) {
  return SetPasswordUseCase(ref.read(accountSecurityRepositoryProvider));
});
