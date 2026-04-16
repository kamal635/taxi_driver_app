import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_names.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/app_confirm_dialog.dart';
import 'package:taxi_driver_app/features/app_update/presentation/widgets/tiles/profile_app_update_item.dart';
import 'package:taxi_driver_app/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile/profile_header_card.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/profile/profile_section_item.dart';

/// Driver profile screen.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  ProviderSubscription<AsyncValue<bool>>? _signOutSubscription;

  @override
  void initState() {
    super.initState();

    _signOutSubscription = ref.listenManual<AsyncValue<bool>>(
      signOutControllerProvider,
      _handleSignOutStateChanged,
    );
  }

  Future<void> _handleSignOutStateChanged(
    AsyncValue<bool>? previous,
    AsyncValue<bool> next,
  ) async {
    await next.whenOrNull(
      error: (error, _) async {
        if (!mounted) {
          return;
        }

        final message = failureToUserMessage(
          error,
          l10n: context.l10n,
        );
        context.showAppSnack(message, type: AppSnackType.error);
      },
      data: (didSignOut) async {
        if (!didSignOut || (previous?.value ?? false) || !mounted) {
          return;
        }

        context.go(AppRoutePaths.login);
      },
    );
  }

  @override
  void dispose() {
    _signOutSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            title: context.l10n.profileSectionAccount,
            children: [
              ProfileSectionItem(
                title: context.l10n.profileChangePasswordTitle,
                subtitle: context.l10n.profileChangePasswordSubtitle,
                icon: AppIcons.lock,
                onPressed: _openChangePasswordPage,
              ),
            ],
          ),
          AppSpacing.h18,
          ProfileSection(
            title: context.l10n.profileSectionApp,
            children: const [
              ProfileAppUpdateItem(),
            ],
          ),
          AppSpacing.h18,
          ProfileSection(
            title: context.l10n.profileSectionSignOut,
            children: [
              ProfileSectionItem(
                isDestructive: true,
                title: context.l10n.profileSignOutTitle,
                subtitle: context.l10n.profileSignOutSubtitle,
                icon: AppIcons.signOut,
                onPressed: _handleSignOutPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openChangePasswordPage() async {
    await context.pushNamed(AppRouteNames.profilePassword);
  }

  Future<void> _handleSignOutPressed() async {
    final confirmed = await _showSignOutConfirmation();

    if (!mounted || !confirmed) {
      return;
    }

    await ref.read(signOutControllerProvider.notifier).signOut();
  }

  Future<bool> _showSignOutConfirmation() async {
    final l10n = context.l10n;

    return showAppConfirmDialog(
      context: context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmMessage,
      confirmLabel: l10n.actionConfirm,
      cancelLabel: l10n.actionCancel,
      barrierDismissible: true,
      icon: AppIcons.signOut,
      iconColor: AppColors.error,
      backgroundColorIcon: AppColors.error.withValues(alpha: 0.10),
    );
  }

  String _safeDisplayValue(String? value) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : '—';
  }
}
