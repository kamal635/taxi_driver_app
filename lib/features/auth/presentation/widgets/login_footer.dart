import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 26.h),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTypography.bodySm,
              children: [
                TextSpan(
                  text: '${context.l10n.contactSupportLabel} ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 2.h,
                      ),
                      child: Text(
                        context.l10n.contactSupportAction,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: '${context.l10n.contactSupportContact} ',
                ),
              ],
            ),
          ),
          AppSpacing.h12,
          Text(
            context.l10n.copyright,
            style: AppTypography.subtitleSm.copyWith(
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}
