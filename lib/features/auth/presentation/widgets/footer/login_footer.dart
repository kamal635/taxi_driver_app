import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_links.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/services/external_url_launcher.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/footer/login_footer_link_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(top: 26.h),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              LoginFooterLinkButton(
                label: l10n.legalPrivacyPolicy,
                onTap: () => _openExternalUrl(AppLinks.privacyPolicy),
              ),
              Text(
                '•',
                style: AppTypography.bodySm.copyWith(
                  color: colors.iconMuted,
                ),
              ),
              LoginFooterLinkButton(
                label: l10n.legalTermsAndConditions,
                onTap: () => _openExternalUrl(AppLinks.termsAndConditions),
              ),
            ],
          ),
          AppSpacing.h12,
          Text(
            l10n.copyright,
            style: AppTypography.subtitleSm.copyWith(
              color: colors.iconMuted,
            ),
          ),
          AppSpacing.h6,
        ],
      ),
    );
  }

  void _openExternalUrl(String url) {
    unawaited(ExternalUrlLauncher.open(url));
  }
}
