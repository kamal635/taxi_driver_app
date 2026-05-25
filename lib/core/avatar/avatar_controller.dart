import 'dart:async';

import 'package:bawabat_al_saeq/core/storage/avatar_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final avatarControllerProvider =
    AsyncNotifierProvider<AvatarController, String?>(AvatarController.new);

/// Manages the local avatar path used by the UI.
final class AvatarController extends AsyncNotifier<String?> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  FutureOr<String?> build() {
    return ref.read(avatarStorageProvider).readAvatarPath();
  }

  /// Picks an image, stores its path locally, and updates the current state.
  Future<void> pickAndSaveAvatar({required ImageSource source}) async {
    if (state.isLoading) return;

    final previousPath = state.value;
    state = const AsyncLoading();

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedImage == null) {
        state = AsyncData(previousPath);
        return;
      }

      final path = pickedImage.path;
      await ref.read(avatarStorageProvider).saveAvatarPath(path: path);
      state = AsyncData(path);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Persists an already known avatar path.
  Future<void> setAvatarPath({required String path}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      await ref.read(avatarStorageProvider).saveAvatarPath(path: path);
      state = AsyncData(path);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Removes the saved avatar path.
  Future<void> clearAvatar() async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      await ref.read(avatarStorageProvider).clearAvatarPath();
      state = const AsyncData(null);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
