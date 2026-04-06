import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/storage/avatar_storage.dart';

/// Provides the avatar local storage implementation.
final avatarStorageProvider = Provider<AvatarStorage>((ref) {
  return AvatarStorage();
});
