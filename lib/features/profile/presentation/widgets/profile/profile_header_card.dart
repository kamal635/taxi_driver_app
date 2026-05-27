import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar_image_editor.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

/// Displays the main driver information block at the top of the profile page.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.name,
    required this.phone,
    required this.avatarSeed,
    super.key,
  });

  final String name;
  final String phone;
  final String avatarSeed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppCardSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarImageEditor(placeholderSeed: avatarSeed),
            AppSpacing.h12,
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSm,
            ),
            AppSpacing.h6,
            Text(
              phone,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.subtitleMd,
            ),
            AppSpacing.h12,
          ],
        ),
      ),
    );
  }
}
