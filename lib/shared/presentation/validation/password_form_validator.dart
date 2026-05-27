/// Centralized password validation helpers.
///
/// Keeping this logic shared prevents duplicated rules between setup-password
/// and change-password experiences.
final class PasswordFormValidator {
  const PasswordFormValidator._();

  static const int defaultMinLength = 8;

  static String? validatePassword({
    required String? value,
    required String requiredMessage,
    required String tooShortMessage,
    int minLength = defaultMinLength,
  }) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return requiredMessage;
    }

    if (password.length < minLength) {
      return tooShortMessage;
    }

    return null;
  }

  static String? validateConfirmation({
    required String? value,
    required String password,
    required String requiredMessage,
    required String tooShortMessage,
    required String mismatchMessage,
    int minLength = defaultMinLength,
  }) {
    final confirmation = value?.trim() ?? '';
    final normalizedPassword = password.trim();

    if (confirmation.isEmpty) {
      return requiredMessage;
    }

    if (confirmation.length < minLength) {
      return tooShortMessage;
    }

    if (confirmation != normalizedPassword) {
      return mismatchMessage;
    }

    return null;
  }

  /// Backward-compatible combined validator for existing callers.
  static String? validate({
    required String password,
    required String confirmPassword,
    required String tooShortMessage,
    required String mismatchMessage,
    int minLength = defaultMinLength,
  }) {
    final normalizedPassword = password.trim();
    final normalizedConfirmation = confirmPassword.trim();

    if (normalizedPassword.length < minLength ||
        normalizedConfirmation.length < minLength) {
      return tooShortMessage;
    }

    if (normalizedPassword != normalizedConfirmation) {
      return mismatchMessage;
    }

    return null;
  }
}
