import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:taxi_driver_app/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.read(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(remote);
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  @override
  Future<AuthSignInResult> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final model = await _remote.signIn(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );

    // model -> domain result (AuthSignedIn أو AuthSetupRequired)
    return model.toEntity();
  }
}
