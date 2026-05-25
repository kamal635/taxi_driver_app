import 'dart:async';

import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';
import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/errors/failure_message_mapper.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/extensions/snackbar_x.dart';
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
import 'package:url_launcher/url_launcher.dart';

/// Driver profile screen.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  static const String _privacyPolicyUrl =
      'https://taxi-dashboard.laithroom.com/privacy-policy';
  static const String _termsAndConditionsUrl =
      'https://taxi-dashboard.laithroom.com/terms-conditions';

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
            title: _isArabic(context)
                ? 'المعلومات القانونية'
                : 'Legal information',
            children: [
              ProfileSectionItem(
                title: _isArabic(context) ? 'سياسة الخصوصية' : 'Privacy Policy',
                subtitle: _isArabic(context)
                    ? 'تعرف على كيفية حماية بياناتك'
                    : 'Learn how your data is protected',
                icon: AppIcons.privacyPolicy,
                onPressed: () => _openExternalUrl(_privacyPolicyUrl),
              ),
              ProfileSectionItem(
                title: _isArabic(context)
                    ? 'الشروط والأحكام'
                    : 'Terms & Conditions',
                subtitle: _isArabic(context)
                    ? 'اقرأ شروط استخدام التطبيق'
                    : 'Read the app terms of use',
                icon: AppIcons.termsAndConditions,
                onPressed: () => _openExternalUrl(_termsAndConditionsUrl),
              ),
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

  bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch) {
      debugPrint('Could not launch $url');
    }
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
