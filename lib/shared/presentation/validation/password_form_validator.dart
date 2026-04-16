/// Centralized password validation helpers.
///
/// Keeping this logic shared prevents duplicated rules between setup-password
/// and change-password experiences.
final class PasswordFormValidator {
  const PasswordFormValidator._();

  static String? validate({
    required String password,
    required String confirmPassword,
    required String tooShortMessage,
    required String mismatchMessage,
    int minLength = 6,
  }) {
    final normalizedPassword = password.trim();
    final normalizedConfirmation = confirmPassword.trim();

    if (normalizedPassword.length < minLength) {
      return tooShortMessage;
    }

    if (normalizedPassword != normalizedConfirmation) {
      return mismatchMessage;
    }

    return null;
  }
}
