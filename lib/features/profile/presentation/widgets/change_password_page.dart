import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppOverlayScaffold(
      title: l10n.profileChangePasswordTitle,
      bottom: AppButton(
        label: l10n.profileUpdatePasswordAction,
        onPressed: () {
          // later: validate + submit
        },
      ),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: AppColors.textPrimary.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Current password field
            AppTextField(
              labelText: l10n.profileCurrentPassword,
              hintText: l10n.passwordHint,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(AppIcons.lock),
              suffixIcon: IconButton(
                color: AppColors.iconMuted,
                onPressed: () {},
                icon: const Icon(
                  AppIcons.eye,
                ),
              ),
            ),

            AppSpacing.h12,

            /// New password field
            AppTextField(
              labelText: l10n.profileNewPassword,
              hintText: l10n.passwordHint,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(AppIcons.lock),
              suffixIcon: IconButton(
                color: AppColors.iconMuted,
                onPressed: () {},
                icon: const Icon(
                  AppIcons.eye,
                ),
              ),
            ),

            AppSpacing.h12,

            /// Confirm new password field
            AppTextField(
              labelText: l10n.profileConfirmNewPassword,
              hintText: l10n.passwordHint,
              textInputAction: TextInputAction.done,
              prefixIcon: const Icon(AppIcons.lock),
              suffixIcon: IconButton(
                color: AppColors.iconMuted,
                onPressed: () {},
                icon: const Icon(
                  AppIcons.eye,
                ),
              ),
            ),

            AppSpacing.h12,

            Text(l10n.profilePasswordHint, style: AppTypography.subtitleSm),
          ],
        ),
      ),
    );
  }
}
