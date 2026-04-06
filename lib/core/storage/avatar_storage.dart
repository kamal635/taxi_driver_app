import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the locally selected avatar file path.
final class AvatarStorage {
  AvatarStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _avatarPathKey = 'avatar_path';

  final FlutterSecureStorage _storage;

  Future<void> saveAvatarPath({required String path}) {
    return _storage.write(key: _avatarPathKey, value: path);
  }

  Future<String?> readAvatarPath() {
    return _storage.read(key: _avatarPathKey);
  }

  Future<void> clearAvatarPath() {
    return _storage.delete(key: _avatarPathKey);
  }
}
