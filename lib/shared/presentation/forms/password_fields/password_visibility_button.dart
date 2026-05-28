import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
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
    final l10n = context.l10n;

    return IconButton(
      color: context.colors.iconMuted,
      tooltip: isObscured ? l10n.authShowPassword : l10n.authHidePassword,
      onPressed: onPressed,
      icon: Icon(
        isObscured ? AppIcons.eyeOff : AppIcons.eye,
      ),
    );
  }
}
