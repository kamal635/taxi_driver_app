import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/router/app_router.dart';
import 'package:taxi_driver_app/app/theme/app_theme.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/utils/screen_util_design_size.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

class TaxiDriverApp extends StatelessWidget {
  const TaxiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: pickDesignSize(),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => child!,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Taxi Driver App',
        onGenerateTitle: (context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: AppTheme.light(const Locale('en')),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
