import 'package:bawabat_al_saeq/app/router/config/app_route_names.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/formatters/profile_display_value_formatter.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/listeners/profile_sign_out_listener.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_account_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_header_card.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_legal_section.dart';
import 'package:bawabat_al_saeq/features/profile/presentation/widgets/profile/profile_sign_out_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Driver profile screen.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final displayName = ref.watch(
      authSessionSnapshotProvider.select(
        (session) => ProfileDisplayValueFormatter.fallbackDash(
          session.driverName,
        ),
      ),
    );
    final phoneNumber = ref.watch(
      authSessionSnapshotProvider.select(
        (session) => ProfileDisplayValueFormatter.fallbackDash(
          session.driverPhone,
        ),
      ),
    );

    return Stack(
      children: [
        const ProfileSignOutListener(),
        SingleChildScrollView(
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
              ProfileAccountSection(
                settings: settings,
                onChangePasswordPressed: () => _open(
                  context,
                  AppRouteNames.profilePassword,
                ),
                onAppearancePressed: () => _open(
                  context,
                  AppRouteNames.profileAppearance,
                ),
                onLanguagePressed: () => _open(
                  context,
                  AppRouteNames.profileLanguage,
                ),
                onLocationStatusPressed: () => _open(
                  context,
                  AppRouteNames.profileLocationStatus,
                ),
              ),
              AppSpacing.h18,
              ProfileLegalSection(
                onAboutPressed: () =>
                    _open(context, AppRouteNames.profileAbout),
              ),
              AppSpacing.h18,
              const ProfileSignOutSection(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context, String routeName) {
    return context.pushNamed(routeName);
  }
}
