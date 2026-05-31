import 'package:bawabat_al_saeq/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:bawabat_al_saeq/features/auth/domain/repositories/auth_repository.dart';

/// Repository implementation for authentication operations.
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSignInResult> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final responseModel = await _remoteDataSource.signIn(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );

    return responseModel.toEntity();
  }
}
