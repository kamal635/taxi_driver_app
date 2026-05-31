import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/about/about_info_card.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/about/about_links_section.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/scaffolds/app_overlay_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// App information and legal/support links screen.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppOverlayScaffold(
      title: l10n.profileAboutTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileAboutPageSubtitle,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.h16,
          FutureBuilder<PackageInfo>(
            future: _packageInfoFuture,
            builder: (context, snapshot) {
              return AboutInfoCard(packageInfo: snapshot.data);
            },
          ),
          AppSpacing.h18,
          const AboutLinksSection(),
        ],
      ),
    );
  }
}
