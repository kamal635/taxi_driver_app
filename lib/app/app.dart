import 'package:bawabat_al_saeq/app/router/providers/go_router_provider.dart';
import 'package:bawabat_al_saeq/app/session/app_force_logout_coordinator.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_providers.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/centered_page.dart';
import 'package:bawabat_al_saeq/core/utils/screen_util_design_size.dart';
import 'package:bawabat_al_saeq/l10n/app_localizations.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/backgrounds/app_background.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/system/app_system_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BawabatAlSaeqApp extends ConsumerWidget {
  const BawabatAlSaeqApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appForceLogoutCoordinatorProvider);

    final router = ref.watch(goRouterProvider);
    final settings = ref.watch(appSettingsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = pickDesignSizeFromConstraints(constraints);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          fontSizeResolver: (fontSize, screenUtil) {
            final scale = screenUtil.scaleText.clamp(0.90, 1.20);
            return fontSize * scale;
          },
          builder: (_, child) => child!,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Bawabat Al Saeq App',
            onGenerateTitle: (context) => context.l10n.appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settings.locale,
            theme: AppTheme.light(settings.locale),
            darkTheme: AppTheme.dark(settings.locale),
            themeMode: settings.themeMode,
            routerConfig: router,
            builder: (context, child) {
              return AppSystemUi(
                child: Stack(
                  children: [
                    const AppBackground(),
                    Positioned.fill(
                      child: CenteredPage(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
