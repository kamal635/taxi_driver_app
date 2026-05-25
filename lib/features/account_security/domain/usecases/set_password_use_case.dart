import 'package:bawabat_al_saeq/features/account_security/domain/repositories/account_security_repository.dart';

/// Executes the set-password flow for the account security feature.
class SetPasswordUseCase {
  const SetPasswordUseCase(this._repository);

  final AccountSecurityRepository _repository;

  Future<String> call({required String newPassword}) {
    return _repository.setPassword(newPassword: newPassword);
  }
}
