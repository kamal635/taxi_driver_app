import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/router/route_names.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_section.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile_section_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToSignOutState(context, ref);

    final l10n = context.l10n;
    final authSession = ref.watch(authSessionProvider);
    final displayName = _safeDisplayValue(authSession.driverName);
    final phoneNumber = _safeDisplayValue(authSession.driverPhone);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h8,
          ProfileHeaderCard(
            name: displayName,
            phone: phoneNumber,
            avatarSeed: displayName,
          ),
          AppSpacing.h18,
          ProfileSection(
            title: l10n.profileSectionAccount,
            children: [
              ProfileSectionItem(
                title: l10n.profileChangePasswordTitle,
                subtitle: l10n.profileChangePasswordSubtitle,
                icon: AppIcons.lock,
                onPressed: () async {
                  await context.pushNamed(RouteNames.profilePassword);
                },
              ),
            ],
          ),
          AppSpacing.h18,
          ProfileSection(
            title: l10n.profileSectionSignOut,
            children: [
              ProfileSectionItem(
                isDestructive: true,
                title: l10n.profileSignOutTitle,
                subtitle: l10n.profileSignOutSubtitle,
                icon: AppIcons.signOut,
                onPressed: () async {
                  final confirmed = await _showSignOutConfirmation(
                    context: context,
                  );

                  if (!context.mounted || !confirmed) return;

                  await ref.read(signOutControllerProvider.notifier).signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _listenToSignOutState(BuildContext context, WidgetRef ref) {
    ref.listen(signOutControllerProvider, (previous, next) async {
      await next.whenOrNull(
        error: (error, _) {
          final message = failureToUserMessage(
            error,
            l10n: context.l10n,
          );
          context.showAppSnack(message, type: AppSnackType.error);
        },
        data: (didSignOut) async {
          if (!didSignOut) return;
          if (previous?.value ?? false) return;

          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        },
      );
    });
  }

  Future<bool> _showSignOutConfirmation({
    required BuildContext context,
  }) async {
    final l10n = context.l10n;

    return showAppConfirmDialog(
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
  }

  String _safeDisplayValue(String? value) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : '—';
  }
}
