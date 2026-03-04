import 'package:taxi_driver_app/features/account_security/domain/repositories/account_security_repository.dart';

class SetPasswordUseCase {
  const SetPasswordUseCase(this._repo);

  final AccountSecurityRepository _repo;

  Future<String> call({
    required String newPassword,
  }) => _repo.setPassword(newPassword: newPassword);
}
