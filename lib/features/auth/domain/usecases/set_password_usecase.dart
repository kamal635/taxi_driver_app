import 'package:taxi_driver_app/features/auth/domain/repositories/auth_repository.dart';

class SetPasswordUseCase {
  const SetPasswordUseCase(this._repo);

  final AuthRepository _repo;

  Future<String> call({
    required String token,
    required String newPassword,
  }) => _repo.setPassword(token: token, newPassword: newPassword);
}
