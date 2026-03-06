import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AvatarStorage {
  AvatarStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _pathKey = 'avatar_path';

  Future<void> saveAvatarPath({required String path}) async {
    await _storage.write(key: _pathKey, value: path);
  }

  Future<String?> readAvatarPath() async {
    return _storage.read(key: _pathKey);
  }

  Future<void> clearAvatarPath() async {
    await _storage.delete(key: _pathKey);
  }
}
