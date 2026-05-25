import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

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
