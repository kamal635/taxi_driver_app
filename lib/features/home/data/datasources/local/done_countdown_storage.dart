import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class DoneCountdownStorage {
  DoneCountdownStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kDoneEndsAtMs = 'done_ends_at_ms';

  Future<void> saveEndsAt(DateTime endsAt) async {
    // Store as UTC milliseconds since epoch.
    final ms = endsAt.toUtc().millisecondsSinceEpoch.toString();
    await _storage.write(key: _kDoneEndsAtMs, value: ms);
  }

  Future<DateTime?> readEndsAt() async {
    final raw = await _storage.read(key: _kDoneEndsAtMs);
    if (raw == null || raw.isEmpty) return null;
    final ms = int.tryParse(raw);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
  }

  Future<void> clear() async {
    await _storage.delete(key: _kDoneEndsAtMs);
  }
}
