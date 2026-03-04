import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/router/route_names.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_section.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_section_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // UI-only data (later from providers)
    const name = 'Ahmad Mohammad';
    const phone = '0987654321';

    ref.listen(signOutControllerProvider, (prev, next) async {
      await next.whenOrNull(
        error: (err, _) {
          final msg = failureToUserMessage(
            err,
            l10n: context.l10n,
          );
          context.showAppSnack(msg, type: AppSnackType.error);
        },
        data: (done) async {
          if (!done) return;
          if (prev?.value ?? false) return;

          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        },
      );
    });
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h8,

          /// profile header with avatar, name, phone
          const ProfileHeaderCard(
            name: name,
            phone: phone,
          ),

          AppSpacing.h18,

          /// account section: change password, my vehicles
          ProfileSection(
            sectionTitle: l10n.profileSectionAccount,
            items: [
              /// change password
              ProfileSectionItem(
                title: l10n.profileChangePasswordTitle,
                subtitle: l10n.profileChangePasswordSubtitle,
                icon: AppIcons.lock,
                onPressed: () async {
                  await context.pushNamed(RouteNames.profilePassword);
                },
              ),

              const _Divider(),

              /// my vehicles
              ProfileSectionItem(
                title: l10n.profileMyVehiclesTitle,
                subtitle: l10n.profileMyVehiclesSubtitle,
                icon: AppIcons.car,
                onPressed: () async {
                  await context.pushNamed(RouteNames.profileVehicles);
                },
              ),
            ],
          ),

          AppSpacing.h18,

          /// account section: help center
          ProfileSection(
            sectionTitle: l10n.profileSectionSupport,
            items: [
              ProfileSectionItem(
                title: l10n.profileHelpCenterTitle,
                subtitle: l10n.profileHelpCenterSubtitle,
                icon: AppIcons.helpCenter,
                onPressed: () {
                  /// later: open help center page
                },
              ),
            ],
          ),

          AppSpacing.h18,

          /// account section: sign out
          ProfileSection(
            sectionTitle: l10n.profileSectionSignOut,
            items: [
              ProfileSectionItem(
                isSignOut: true,
                title: l10n.profileSignOutTitle,
                subtitle: l10n.profileSignOutSubtitle,
                icon: AppIcons.signOut,
                onPressed: () async {
                  final confirmed = await showAppConfirmDialog(
                    context: context,
                    title: l10n.signOutConfirmTitle,
                    message: l10n.signOutConfirmMessage,
                    confirmLabel: l10n.actionConfirm,
                    cancelLabel: l10n.actionCancel,
                    barrierDismissible: true,
                    icon: Icons.logout_rounded,
                    iconColor: Colors.red,
                    backgroundColorIcon: Colors.red.withValues(alpha: 0.10),
                  );

                  if (!context.mounted) return;

                  if (confirmed) {
                    await ref
                        .read(signOutControllerProvider.notifier)
                        .signOut();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2.h,
      thickness: 1,
      color: AppColors.border,
    );
  }
}
