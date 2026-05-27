import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';
import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/constants/app_links.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
import 'package:bawabat_al_saeq/core/services/external_url_launcher.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/core/widgets/app_confirm_dialog.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/controllers/sign_out_controller.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_header_card.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_section_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
        ref.read(signOutControllerProvider.notifier).reset();
      },
      data: (didSignOut) async {
        if (!didSignOut || (previous?.asData?.value ?? false) || !mounted) {
          return;
        }

        ref.read(signOutControllerProvider.notifier).reset();
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
    final l10n = context.l10n;
    final authSession = ref.watch(authSessionProvider);
    final isSigningOut = ref.watch(
      signOutControllerProvider.select((state) => state.isLoading),
    );
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
                onPressed: _openChangePasswordPage,
              ),
            ],
          ),
          AppSpacing.h18,
          ProfileSection(
            title: l10n.profileSectionLegal,
            children: [
              ProfileSectionItem(
                title: l10n.legalPrivacyPolicy,
                subtitle: l10n.profilePrivacyPolicySubtitle,
                icon: AppIcons.privacyPolicy,
                onPressed: () => unawaited(
                  ExternalUrlLauncher.open(AppLinks.privacyPolicy),
                ),
              ),
              ProfileSectionItem(
                title: l10n.legalTermsAndConditions,
                subtitle: l10n.profileTermsAndConditionsSubtitle,
                icon: AppIcons.termsAndConditions,
                onPressed: () => unawaited(
                  ExternalUrlLauncher.open(AppLinks.termsAndConditions),
                ),
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
                onPressed: isSigningOut ? null : _handleSignOutPressed,
                trailing: isSigningOut
                    ? SizedBox.square(
                        dimension: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
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
