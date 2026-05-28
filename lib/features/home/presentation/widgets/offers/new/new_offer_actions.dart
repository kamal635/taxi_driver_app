import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// Action row for a pending offer.
class NewOfferActions extends StatelessWidget {
  const NewOfferActions({
    required this.isAcceptLoading,
    required this.isDeclineLoading,
    this.onAccept,
    this.onDecline,
    super.key,
  });

  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final bool isAcceptLoading;
  final bool isDeclineLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isBusy = isAcceptLoading || isDeclineLoading;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppButton(
            borderColor: colors.error,
            labelColor: colors.error,
            backgroundColor: Colors.transparent,
            label: l10n.decline,
            onPressed: isBusy ? null : onDecline,
            isLoading: isDeclineLoading,
          ),
        ),
        AppSpacing.w8,
        Expanded(
          flex: 3,
          child: AppButton(
            isLoading: isAcceptLoading,
            label: l10n.actionAccept,
            onPressed: isBusy ? null : onAccept,
          ),
        ),
      ],
    );
  }
}
