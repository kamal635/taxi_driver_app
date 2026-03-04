import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/core/widgets/app_text_field.dart';
import 'package:taxi_driver_app/features/account_security/presentation/controllers/setup_password_controller.dart';

class SetupPasswordPage extends ConsumerStatefulWidget {
  const SetupPasswordPage({super.key});

  @override
  ConsumerState<SetupPasswordPage> createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends ConsumerState<SetupPasswordPage> {
  late final TextEditingController _newPassword;
  late final TextEditingController _confirmNewPassword;

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newPassword = TextEditingController();
    _confirmNewPassword = TextEditingController();
  }

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmNewPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authSession = ref.read(authSessionProvider);
    final l10n = context.l10n;

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
          if (msg == null) return;

          // avoid duplicate snack on rebuild
          if (msg == prev?.value) return;
          await Future(() async {
            await authSession.markPasswordCreated();

            if (context.mounted) {
              context.showAppSnack(msg, type: AppSnackType.success);
            }
            ref.read(setupPasswordControllerProvider.notifier).reset();
            if (context.mounted) {
              context.go(AppRoutes.home);
            }
          });
        },
      );
    });

    final setupState = ref.watch(setupPasswordControllerProvider);
    final isLoading = setupState.isLoading;

    return AppOverlayScaffold(
      title: l10n.authSetupPasswordTitle,
      bottom: AppButton(
        isLoading: isLoading,
        label: l10n.authCreatePasswordAction,
        onPressed: isLoading
            ? null
            : () async {
                final newPass = _newPassword.text.trim();
                final confirm = _confirmNewPassword.text.trim();

                if (newPass.length < 6) {
                  context.showAppSnack(
                    l10n.authPasswordRulesHint,
                    type: AppSnackType.warning,
                  );
                  return;
                }
                if (newPass != confirm) {
                  context.showAppSnack(
                    l10n.errorValidation,
                    type: AppSnackType.warning,
                  );
                  return;
                }

                await ref
                    .read(setupPasswordControllerProvider.notifier)
                    .submit(
                      newPassword: newPass,
                    );
              },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.authSetupPasswordSubtitle, style: AppTypography.subtitleMd),
          AppSpacing.h12,
          Container(
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
                AppTextField(
                  controller: _newPassword,
                  obscureText: _obscureNew,
                  labelText: l10n.authNewPasswordLabel,
                  hintText: l10n.passwordHint,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(AppIcons.lock),
                  suffixIcon: IconButton(
                    color: AppColors.iconMuted,
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    icon: Icon(_obscureNew ? AppIcons.eye : AppIcons.eyeOff),
                  ),
                ),
                AppSpacing.h12,
                AppTextField(
                  controller: _confirmNewPassword,
                  obscureText: _obscureConfirm,
                  labelText: l10n.authConfirmNewPasswordLabel,
                  hintText: l10n.passwordHint,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(AppIcons.lock),
                  suffixIcon: IconButton(
                    color: AppColors.iconMuted,
                    onPressed: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                    icon: Icon(
                      _obscureConfirm ? AppIcons.eye : AppIcons.eyeOff,
                    ),
                  ),
                ),
                AppSpacing.h12,
                Text(
                  l10n.authPasswordRulesHint,
                  style: AppTypography.subtitleSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
