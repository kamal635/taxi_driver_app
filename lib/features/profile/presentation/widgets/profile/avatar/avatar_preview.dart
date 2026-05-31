import 'dart:io';

import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar/avatar_fallback_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarPreview extends StatelessWidget {
  const AvatarPreview({
    required this.avatarPath,
    required this.fallbackInitial,
    super.key,
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
          color: context.colors.primary.withValues(alpha: 0.55),
          width: 3,
        ),
        color: context.colors.surfaceMuted,
      ),
      child: hasAvatar
          ? ClipOval(
              child: Image.file(
                File(avatarPath!),
                width: 92.r,
                height: 92.r,
                fit: BoxFit.cover,
                cacheWidth: 184,
                filterQuality: FilterQuality.low,
                errorBuilder: (_, _, _) => AvatarFallbackText(
                  initial: fallbackInitial,
                ),
              ),
            )
          : AvatarFallbackText(initial: fallbackInitial),
    );
  }
}
