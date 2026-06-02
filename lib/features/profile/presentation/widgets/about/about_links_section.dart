import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/constants/app_links.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/services/external_url_launcher.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:flutter/material.dart';

class AboutLinksSection extends StatelessWidget {
  const AboutLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ProfileSection(
      title: l10n.aboutLinksSectionTitle,
      children: [
        ProfileSectionItem(
          title: l10n.legalPrivacyPolicy,
          subtitle: l10n.profilePrivacyPolicySubtitle,
          icon: AppIcons.privacyPolicy,
          onPressed: () => unawaited(
            ExternalUrlLauncher.open(AppLinks.privacyPolicy),
          ),
        ),
        ProfileSectionItem(
          title: l10n.legalTermsAndConditions,
          subtitle: l10n.profileTermsAndConditionsSubtitle,
          icon: AppIcons.termsAndConditions,
          onPressed: () => unawaited(
            ExternalUrlLauncher.open(AppLinks.termsAndConditions),
          ),
        ),
        // ProfileSectionItem(
        //   title: l10n.aboutSupportTitle,
        //   subtitle: l10n.aboutSupportSubtitle,
        //   icon: Icons.support_agent_rounded,
        //   onPressed: () => unawaited(
        //     ExternalUrlLauncher.open(AppLinks.support),
        //   ),
        // ),
      ],
    );
  }
}
