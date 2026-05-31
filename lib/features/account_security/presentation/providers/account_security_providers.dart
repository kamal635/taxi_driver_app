import 'package:bawabat_al_saeq/core/networking/providers/network_client_providers.dart';
import 'package:bawabat_al_saeq/features/account_security/data/datasources/remote/account_security_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/account_security/data/repositories/account_security_repository_impl.dart';
import 'package:bawabat_al_saeq/features/account_security/domain/repositories/account_security_repository.dart';
import 'package:bawabat_al_saeq/features/account_security/domain/usecases/set_password_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the remote data source used by the feature.
final accountSecurityRemoteDataSourceProvider =
    Provider<AccountSecurityRemoteDataSource>((ref) {
      return AccountSecurityRemoteDataSourceImpl(ref.read(apiClientProvider));
    });

/// Provides the repository implementation used by the feature.
final accountSecurityRepositoryProvider = Provider<AccountSecurityRepository>(
  (ref) {
    return AccountSecurityRepositoryImpl(
      ref.read(accountSecurityRemoteDataSourceProvider),
    );
  },
);

/// Provides the use case responsible for creating the driver's password.
final setPasswordUseCaseProvider = Provider<SetPasswordUseCase>((ref) {
  return SetPasswordUseCase(ref.read(accountSecurityRepositoryProvider));
});
