import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/about/about_info_row.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutInfoCard extends StatelessWidget {
  const AboutInfoCard({required this.packageInfo, super.key});

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
          AboutInfoRow(
            label: l10n.aboutVersionLabel,
            value: version,
          ),
        ],
      ),
    );
  }
}
