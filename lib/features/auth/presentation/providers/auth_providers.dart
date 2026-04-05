import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taxi_driver_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taxi_driver_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/sign_in_use_case.dart';

/// Provides the remote data source used by the auth feature.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(apiClientProvider));
});

/// Provides the auth repository implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

/// Provides the sign-in use case.
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});
