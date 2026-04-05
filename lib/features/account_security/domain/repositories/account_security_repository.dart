/// Contract for account security domain operations.
abstract class AccountSecurityRepository {
  /// Persists the new password and returns the backend message.
  Future<String> setPassword({required String newPassword});
}
