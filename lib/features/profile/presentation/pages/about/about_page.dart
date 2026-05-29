import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/constants/app_links.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/services/external_url_launcher.dart';
import 'package:bawabat_al_saeq/core/widgets/app_overlay_scaffold.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// App information and legal links screen.
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
              final packageInfo = snapshot.data;

              return _AboutInfoCard(packageInfo: packageInfo);
            },
          ),
          AppSpacing.h18,
          ProfileSection(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutInfoCard extends StatelessWidget {
  const _AboutInfoCard({required this.packageInfo});

  final PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appName = packageInfo?.appName.trim();
    final version = packageInfo == null
        ? l10n.aboutVersionUnavailable
        : '${packageInfo!.version}+${packageInfo!.buildNumber}';

    return AppCardSurface(
      child: Column(
        children: [
          Container(
            width: 92.r,
            height: 92.r,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: context.colors.backgroundDecorative,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: context.colors.border),
            ),
            child: Image.asset(
              'assets/images/app_icon_foreground.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.local_taxi_rounded,
                size: 38.r,
                color: context.colors.primary,
              ),
            ),
          ),
          AppSpacing.h14,
          Text(
            (appName != null && appName.isNotEmpty)
                ? appName
                : l10n.profileAboutTitle,
            textAlign: TextAlign.center,
            style: AppTypography.titleSm.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.h16,
          _AboutInfoRow(
            label: l10n.aboutVersionLabel,
            value: version,
          ),
        ],
      ),
    );
  }
}

class _AboutInfoRow extends StatelessWidget {
  const _AboutInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.colors.backgroundDecorative,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.w10,
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              textDirection: TextDirection.ltr,
              style: AppTypography.labelSm.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
