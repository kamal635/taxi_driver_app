import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    required this.title,
    this.message,
    super.key,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 40,
                ),
                AppSpacing.h12,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleSm,
                ),
                if (message != null && message!.trim().isNotEmpty) ...[
                  AppSpacing.h8,
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitleMd,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
