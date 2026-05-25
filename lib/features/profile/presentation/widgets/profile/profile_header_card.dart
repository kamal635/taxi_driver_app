import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/avatar_image_editor.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

/// Displays the main user information block at the top of the profile page.
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
    return AppCardSurface(
      child: Column(
        children: [
          AvatarImageEditor(placeholderSeed: avatarSeed),
          AppSpacing.h12,
          Text(name, style: AppTypography.titleSm),
          AppSpacing.h6,
          Text(phone, style: AppTypography.subtitleMd),
          AppSpacing.h12,
        ],
      ),
    );
  }
}
