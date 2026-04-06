import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/avatar/avatar_controller.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

/// Displays the current avatar and lets the user change or remove it.
class AvatarImageEditor extends ConsumerWidget {
  const AvatarImageEditor({
    required this.placeholderSeed,
    super.key,
  });

  final String placeholderSeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarState = ref.watch(avatarControllerProvider);
    final avatarPath = avatarState.value;
    final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;
    final isBusy = avatarState.isLoading;
    final fallbackInitial = _buildFallbackInitial(placeholderSeed);

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _AvatarPreview(
          avatarPath: avatarPath,
          fallbackInitial: fallbackInitial,
        ),
        Positioned(
          left: 2.w,
          bottom: 2.h,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: isBusy
                ? null
                : () => _showAvatarActions(
                    context: context,
                    ref: ref,
                    hasAvatar: hasAvatar,
                  ),
            child: Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: AppColors.border),
              ),
              child: isBusy
                  ? Padding(
                      padding: EdgeInsets.all(8.r),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      AppIcons.camera,
                      size: 18.r,
                      color: AppColors.textPrimary,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildFallbackInitial(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty ? trimmed[0] : '—';
  }

  Future<void> _showAvatarActions({
    required BuildContext context,
    required WidgetRef ref,
    required bool hasAvatar,
  }) async {
    final l10n = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(AppIcons.changePhoto),
                title: Text(l10n.profileAvatarChangePhoto),
                onTap: () async {
                  context.pop();
                  await _showPickSource(context: context, ref: ref);
                },
              ),
              ListTile(
                enabled: hasAvatar,
                leading: const Icon(
                  AppIcons.delete,
                  color: AppColors.error,
                ),
                title: Text(
                  l10n.profileAvatarRemovePhoto,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: hasAvatar
                    ? () async {
                        context.pop();
                        await ref
                            .read(avatarControllerProvider.notifier)
                            .clearAvatar();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPickSource({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final l10n = context.l10n;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (_) {
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
      },
    );

    if (source == null) return;

    await ref
        .read(avatarControllerProvider.notifier)
        .pickAndSaveAvatar(source: source);
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.avatarPath,
    required this.fallbackInitial,
  });

  final String? avatarPath;
  final String fallbackInitial;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarPath != null && avatarPath!.isNotEmpty;

    return Container(
      width: 92.r,
      height: 92.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.55),
          width: 3,
        ),
        color: AppColors.bgBase,
      ),
      child: hasAvatar
          ? ClipOval(
              child: Image.file(
                File(avatarPath!),
                width: 92.r,
                height: 92.r,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _AvatarFallbackText(
                  initial: fallbackInitial,
                ),
              ),
            )
          : _AvatarFallbackText(initial: fallbackInitial),
    );
  }
}

class _AvatarFallbackText extends StatelessWidget {
  const _AvatarFallbackText({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Text(
      initial,
      style: AppTypography.titleSm.copyWith(
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
