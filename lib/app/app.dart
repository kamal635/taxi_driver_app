import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/router/app_router.dart';
import 'package:taxi_driver_app/app/theme/app_theme.dart';

class TaxiDriverApp extends StatelessWidget {
  const TaxiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Driver App',
      routerConfig: AppRouter.router,
      theme: AppTheme.light(
        isArabic: false,
      ), // default (will be overridden below)
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        final isArabic = locale.languageCode == 'ar';

        return Theme(
          data: AppTheme.light(isArabic: isArabic),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
