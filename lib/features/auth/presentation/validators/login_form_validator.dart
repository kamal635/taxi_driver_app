/// Validation helpers used by the login form.
final class LoginFormValidator {
  const LoginFormValidator._();

  static String? requiredField(String? value, {required String message}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }
}
