import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/change_password_form.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(setupPasswordControllerProvider, (prev, next) async {
      await next.whenOrNull(
        error: (err, _) {
          final msg = failureToUserMessage(
            err,
            l10n: context.l10n,
          );
          context.showAppSnack(msg, type: AppSnackType.error);
        },
        data: (msg) async {
          if (msg == null || msg.isEmpty) return;

          // avoid duplicate snack on rebuild
          if (msg == prev?.value) return;

          context.showAppSnack(msg, type: AppSnackType.success);

          // reset so it won't re-fire
          ref.read(setupPasswordControllerProvider.notifier).reset();

          if (context.mounted) context.pop();
        },
      );
    });

    final l10n = context.l10n;
    final async = ref.watch(setupPasswordControllerProvider);
    final isLoading = async.isLoading;

    return AppOverlayScaffold(
      title: l10n.profileChangePasswordTitle,
      bottom: AppButton(
        label: l10n.profileUpdatePasswordAction,
        isLoading: isLoading,
        onPressed: isLoading ? null : _submit,
      ),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: AppColors.textPrimary.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangePasswordForm(
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
              obscureNew: _obscureNew,
              obscureConfirm: _obscureConfirm,
              onToggleNewVisibility: () =>
                  setState(() => _obscureNew = !_obscureNew),
              onToggleConfirmVisibility: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              enabled: !isLoading,
            ),
            AppSpacing.h12,
            Text(l10n.profilePasswordHint, style: AppTypography.subtitleSm),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = context.l10n;

    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPass.length < 6) {
      context.showAppSnack(
        l10n.authPasswordRulesHint,
        type: AppSnackType.error,
      );
      return;
    }

    if (newPass != confirm) {
      context.showAppSnack(
        l10n.errorValidation,
        type: AppSnackType.error,
      );
      return;
    }

    await ref
        .read(setupPasswordControllerProvider.notifier)
        .submit(
          newPassword: newPass,
        );
  }
}
