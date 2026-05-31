import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/avatar/avatar_controller.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/formatters/profile_display_value_formatter.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar/avatar_actions_sheet.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar/avatar_preview.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar/avatar_source_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final fallbackInitial = ProfileDisplayValueFormatter.firstInitial(
      placeholderSeed,
    );

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        AvatarPreview(
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
                border: Border.all(color: context.colors.border),
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

  Future<void> _showAvatarActions({
    required BuildContext context,
    required WidgetRef ref,
    required bool hasAvatar,
  }) {
    return AvatarActionsSheet.show(
      context: context,
      hasAvatar: hasAvatar,
      onChangePhotoPressed: () => unawaited(_pickAvatar(context, ref)),
      onRemovePhotoPressed: () => unawaited(
        ref.read(avatarControllerProvider.notifier).clearAvatar(),
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context, WidgetRef ref) async {
    final source = await AvatarSourceSheet.show(context);
    if (source == null) {
      return;
    }

    await ref
        .read(avatarControllerProvider.notifier)
        .pickAndSaveAvatar(
          source: source,
        );
  }
}
