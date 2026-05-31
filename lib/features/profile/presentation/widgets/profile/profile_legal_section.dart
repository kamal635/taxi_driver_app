import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:flutter/material.dart';

class ProfileLegalSection extends StatelessWidget {
  const ProfileLegalSection({required this.onAboutPressed, super.key});

  final VoidCallback onAboutPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ProfileSection(
      title: l10n.profileSectionLegal,
      children: [
        ProfileSectionItem(
          title: l10n.profileAboutTitle,
          subtitle: l10n.profileAboutSubtitle,
          icon: Icons.info_outline_rounded,
          onPressed: onAboutPressed,
        ),
      ],
    );
  }
}
