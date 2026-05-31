import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSourceSheet extends StatelessWidget {
  const AvatarSourceSheet({super.key});

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (_) => const AvatarSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(AppIcons.gallery),
            title: Text(l10n.profileAvatarPickFromGallery),
            onTap: () => context.pop(ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(AppIcons.camera),
            title: Text(l10n.profileAvatarTakePhoto),
            onTap: () => context.pop(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
