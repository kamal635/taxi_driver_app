import 'package:bawabat_al_saeq/features/account_security/domain/repositories/account_security_repository.dart';

/// Executes the first-time password creation flow.
final class SetPasswordUseCase {
  const SetPasswordUseCase(this._repository);

  final AccountSecurityRepository _repository;

  Future<String?> call({required String newPassword}) {
    return _repository.setPassword(newPassword: newPassword);
  }
}
