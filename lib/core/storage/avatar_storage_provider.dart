import 'package:bawabat_al_saeq/core/storage/avatar_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the avatar local storage implementation.
final avatarStorageProvider = Provider<AvatarStorage>((ref) {
  return AvatarStorage();
});
