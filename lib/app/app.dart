import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/router/app_router.dart';
import 'package:taxi_driver_app/core/utils/screen_util_design_size.dart';

class TaxiDriverApp extends StatelessWidget {
  const TaxiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: pickDesignSize(),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Taxi Driver App',
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
