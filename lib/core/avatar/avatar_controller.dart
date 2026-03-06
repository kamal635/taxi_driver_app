import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_driver_app/core/storage/avatar_storage_provider.dart';

final avatarControllerProvider =
    AsyncNotifierProvider<AvatarController, String?>(AvatarController.new);

final class AvatarController extends AsyncNotifier<String?> {
  final ImagePicker _picker = ImagePicker();

  @override
  FutureOr<String?> build() {
    // Load saved avatar path (if any) on first build
    return ref.read(avatarStorageProvider).readAvatarPath();
  }

  /// Picks an image (camera/gallery), saves its path, and updates state.
  Future<void> pickAndSaveAvatar({required ImageSource source}) async {
    if (state.isLoading) return;

    final previousPath = state.value; // keep current value (if any)
    state = const AsyncLoading();

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85, // optional: smaller size
      );

      // User cancelled -> restore previous state
      if (picked == null) {
        state = AsyncData(previousPath);
        return;
      }

      final path = picked.path;

      await ref.read(avatarStorageProvider).saveAvatarPath(path: path);

      // Update UI immediately
      state = AsyncData(path);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// If you already have a path from somewhere else, save it directly.
  Future<void> setAvatarPath({required String path}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      await ref.read(avatarStorageProvider).saveAvatarPath(path: path);
      state = AsyncData(path);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> clearAvatar() async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      await ref.read(avatarStorageProvider).clearAvatarPath();
      state = const AsyncData(null);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
