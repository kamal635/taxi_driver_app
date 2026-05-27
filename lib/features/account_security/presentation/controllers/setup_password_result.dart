/// Successful password-setup submission result.
///
/// [submissionId] makes every successful submit unique, even if the backend
/// returns the same message more than once. This prevents listener code from
/// missing a second success because the previous data value was identical.
final class SetupPasswordResult {
  const SetupPasswordResult({
    required this.submissionId,
    this.message,
  });

  final int submissionId;
  final String? message;
}
