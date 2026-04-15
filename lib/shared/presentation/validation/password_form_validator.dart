final class PasswordFormValidator {
  const PasswordFormValidator._();

  static String? validate({
    required String password,
    required String confirmPassword,
    required String tooShortMessage,
    required String mismatchMessage,
    int minLength = 6,
  }) {
    if (password.length < minLength) {
      return tooShortMessage;
    }

    if (password != confirmPassword) {
      return mismatchMessage;
    }

    return null;
  }
}
