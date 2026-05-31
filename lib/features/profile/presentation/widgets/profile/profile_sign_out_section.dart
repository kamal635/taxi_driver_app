import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/dialogs/app_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSignOutSection extends ConsumerWidget {
  const ProfileSignOutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isSigningOut = ref.watch(
      signOutControllerProvider.select((state) => state.isLoading),
    );

    return ProfileSection(
      title: l10n.profileSectionSignOut,
      children: [
        ProfileSectionItem(
          isDestructive: true,
          title: l10n.profileSignOutTitle,
          subtitle: l10n.profileSignOutSubtitle,
          icon: AppIcons.signOut,
          onPressed: isSigningOut
              ? null
              : () => _handleSignOutPressed(context, ref),
          trailing: isSigningOut
              ? SizedBox.square(
                  dimension: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
      ],
    );
  }

  Future<void> _handleSignOutPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await _showSignOutConfirmation(context);

    if (!context.mounted || !confirmed) {
      return;
    }

    await ref.read(signOutControllerProvider.notifier).signOut();
  }

  Future<bool> _showSignOutConfirmation(BuildContext context) {
    final l10n = context.l10n;

    return showAppConfirmDialog(
      context: context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmMessage,
      confirmLabel: l10n.actionConfirm,
      cancelLabel: l10n.actionCancel,
      barrierDismissible: true,
      icon: AppIcons.signOut,
      iconColor: context.colors.error,
      backgroundColorIcon: context.colors.errorBg,
    );
  }
}
