import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

class AppOverlayScaffold extends StatelessWidget {
  const AppOverlayScaffold({
    required this.title,
    required this.child,
    this.bottom,
    this.padding,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? bottom;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: AppTypography.titleSm),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding ?? EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Column(
            children: [
              child,
              if (bottom != null) ...[
                AppSpacing.h16,
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
