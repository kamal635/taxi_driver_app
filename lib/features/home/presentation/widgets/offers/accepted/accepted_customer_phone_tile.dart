import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tappable phone tile for the accepted offer customer.
class AcceptedCustomerPhoneTile extends StatelessWidget {
  const AcceptedCustomerPhoneTile({
    required this.customerPhone,
    super.key,
  });

  final String customerPhone;

  Future<void> _callCustomer() async {
    final phone = customerPhone.trim();
    if (phone.isEmpty) return;

    await launchUrl(
      Uri(scheme: 'tel', path: phone),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final hasPhone = customerPhone.trim().isNotEmpty;

    return Column(
      children: [
        Divider(
          color: colors.iconMuted,
          height: 1,
        ),
        AppSpacing.h12,
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: hasPhone ? _callCustomer : null,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.phone,
                      color: colors.primary,
                      size: 28.r,
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasPhone ? customerPhone : l10n.unknown,
                          style: AppTypography.titleSm.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          l10n.tapToCall,
                          style: AppTypography.subtitleMd,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    AppIcons.arrowForward,
                    color: colors.iconMuted,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
