import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

/// Shared password visibility toggle button.
class PasswordVisibilityButton extends StatelessWidget {
  const PasswordVisibilityButton({
    required this.isObscured,
    required this.onPressed,
    super.key,
  });

  final bool isObscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: AppColors.iconMuted,
      tooltip: isObscured ? 'Show password' : 'Hide password',
      onPressed: onPressed,
      icon: Icon(
        isObscured ? AppIcons.eye : AppIcons.eyeOff,
      ),
    );
  }
}
