import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
  });

  static const String _privacyPolicyUrl =
      'https://taxi-dashboard.laithroom.com/privacy-policy';
  static const String _termsAndConditionsUrl =
      'https://taxi-dashboard.laithroom.com/terms-conditions';

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
              _FooterLinkButton(
                label: isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                onTap: () => _openExternalUrl(_privacyPolicyUrl),
              ),
              Text(
                '•',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.iconMuted,
                  fontFamily: 'NotoKufiArabic',
                ),
              ),
              _FooterLinkButton(
                label: isArabic ? 'الشروط والأحكام' : 'Terms & Conditions',
                onTap: () => _openExternalUrl(_termsAndConditionsUrl),
              ),
            ],
          ),
          AppSpacing.h12,
          Text(
            context.l10n.copyright,
            style: AppTypography.subtitleSm.copyWith(
              color: AppColors.iconMuted,
            ),
          ),
          AppSpacing.h6,
        ],
      ),
    );
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch) {
      debugPrint('Could not launch $url');
    }
  }
}

class _FooterLinkButton extends StatelessWidget {
  const _FooterLinkButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 4.h,
        ),
        child: Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.primary,
            fontFamily: 'NotoKufiArabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
