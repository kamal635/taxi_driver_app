/// Contract for account-security domain operations.
abstract interface class AccountSecurityRepository {
  /// Persists the new password and returns an optional backend message.
  Future<String?> setPassword({required String newPassword});
}
