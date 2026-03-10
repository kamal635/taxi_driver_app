import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/router/router_providers.dart';
import 'package:taxi_driver_app/app/theme/app_theme.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/utils/centered_page.dart';
import 'package:taxi_driver_app/core/utils/screen_util_design_size.dart';
import 'package:taxi_driver_app/core/widgets/app_background.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

class TaxiDriverApp extends ConsumerWidget {
  const TaxiDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = pickDesignSizeFromConstraints(constraints);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,

          fontSizeResolver: (fontSize, su) {
            final scale = su.scaleText.clamp(0.90, 1.20);
            return fontSize * scale;
          },

          builder: (_, child) => child!,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Taxi Driver App',
            onGenerateTitle: (context) => context.l10n.appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            theme: AppTheme.light(const Locale('en')),
            routerConfig: router,
            builder: (context, child) {
              return Stack(
                children: [
                  const AppBackground(),
                  Positioned.fill(
                    child: CenteredPage(
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
