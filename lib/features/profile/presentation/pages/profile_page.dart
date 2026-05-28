import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';
import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
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
    final appSettings = ref.watch(appSettingsProvider);
    final isArabicLocale = appSettings.isArabic;
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
              ProfileSectionItem(
                title: l10n.profileAppearanceTitle,
                subtitle: _themeModeSubtitle(context, appSettings.themeMode),
                icon: _themeModeIcon(appSettings.themeMode),
                onPressed: _openAppearancePage,
              ),
              ProfileSectionItem(
                title: l10n.profileLanguageTitle,
                subtitle: isArabicLocale
                    ? l10n.profileLanguageArabicSubtitle
                    : l10n.profileLanguageEnglishSubtitle,
                icon: Icons.language_rounded,
                onPressed: _openLanguagePage,
                trailing: _LanguageCodeBadge(
                  label: isArabicLocale ? 'AR' : 'EN',
                ),
              ),
              ProfileSectionItem(
                title: l10n.profileLocationStatusTitle,
                subtitle: l10n.profileLocationStatusSubtitle,
                icon: Icons.location_on_rounded,
                onPressed: _openLocationStatusPage,
              ),
            ],
          ),
          AppSpacing.h18,
          ProfileSection(
            title: l10n.profileSectionLegal,
            children: [
              ProfileSectionItem(
                title: l10n.profileAboutTitle,
                subtitle: l10n.profileAboutSubtitle,
                icon: Icons.info_outline_rounded,
                onPressed: _openAboutPage,
              ),
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

  Future<void> _openLanguagePage() async {
    await context.pushNamed(AppRouteNames.profileLanguage);
  }

  Future<void> _openAppearancePage() async {
    await context.pushNamed(AppRouteNames.profileAppearance);
  }

  Future<void> _openLocationStatusPage() async {
    await context.pushNamed(AppRouteNames.profileLocationStatus);
  }

  Future<void> _openAboutPage() async {
    await context.pushNamed(AppRouteNames.profileAbout);
  }

  String _themeModeSubtitle(BuildContext context, ThemeMode themeMode) {
    final l10n = context.l10n;

    return switch (themeMode) {
      ThemeMode.system => l10n.profileAppearanceSystemTitle,
      ThemeMode.light => l10n.profileAppearanceLightTitle,
      ThemeMode.dark => l10n.profileAppearanceDarkTitle,
    };
  }

  IconData _themeModeIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
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
      iconColor: context.colors.error,
      backgroundColorIcon: context.colors.errorBg,
    );
  }

  String _safeDisplayValue(String? value) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : '—';
  }
}

class _LanguageCodeBadge extends StatelessWidget {
  const _LanguageCodeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.colors.backgroundDecorative,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: AppTypography.labelSm.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
