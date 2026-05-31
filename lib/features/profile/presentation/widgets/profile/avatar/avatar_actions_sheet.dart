import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvatarActionsSheet extends StatelessWidget {
  const AvatarActionsSheet({
    required this.hasAvatar,
    required this.onChangePhotoPressed,
    required this.onRemovePhotoPressed,
    super.key,
  });

  final bool hasAvatar;
  final VoidCallback onChangePhotoPressed;
  final VoidCallback onRemovePhotoPressed;

  static Future<void> show({
    required BuildContext context,
    required bool hasAvatar,
    required VoidCallback onChangePhotoPressed,
    required VoidCallback onRemovePhotoPressed,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => AvatarActionsSheet(
        hasAvatar: hasAvatar,
        onChangePhotoPressed: onChangePhotoPressed,
        onRemovePhotoPressed: onRemovePhotoPressed,
      ),
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
            leading: const Icon(AppIcons.changePhoto),
            title: Text(l10n.profileAvatarChangePhoto),
            onTap: () {
              context.pop();
              onChangePhotoPressed();
            },
          ),
          ListTile(
            enabled: hasAvatar,
            leading: Icon(AppIcons.delete, color: context.colors.error),
            title: Text(
              l10n.profileAvatarRemovePhoto,
              style: TextStyle(color: context.colors.error),
            ),
            onTap: hasAvatar
                ? () {
                    context.pop();
                    onRemovePhotoPressed();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
