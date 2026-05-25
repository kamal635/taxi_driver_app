import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  static const _logoAssetPath = 'assets/images/app_icon_foreground.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.h18,
        Image.asset(
          _logoAssetPath,
          height: 160.r,
          width: 160.r,
        ),

        Text(
          context.l10n.brandName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleLg,
        ),
        AppSpacing.h10,
        Text(
          context.l10n.brandSubtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.subtitleMd,
        ),
        AppSpacing.h24,
      ],
    );
  }
}
