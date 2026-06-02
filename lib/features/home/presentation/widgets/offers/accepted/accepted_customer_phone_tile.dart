import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tappable customer phone row for accepted offers.
///
/// It is kept flat inside the main offer card to avoid stacking too many
/// internal cards on the screen.
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
    final phone = customerPhone.trim();
    final hasPhone = phone.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: hasPhone ? _callCustomer : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.phone,
                  color: colors.primary,
                  size: 25.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        hasPhone ? phone : l10n.unknown,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSm.copyWith(
                          color: colors.textPrimary,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      l10n.tapToCall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMd.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                AppIcons.arrowForward,
                color: colors.iconMuted,
                size: 18.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
