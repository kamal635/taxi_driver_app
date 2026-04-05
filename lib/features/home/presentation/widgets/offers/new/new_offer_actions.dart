import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

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

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppButton(
            borderColor: AppColors.error,
            labelColor: AppColors.error,
            backgroundColor: Colors.transparent,
            label: l10n.decline,
            onPressed: onDecline,
            isLoading: isDeclineLoading,
          ),
        ),
        AppSpacing.w8,
        Expanded(
          flex: 3,
          child: AppButton(
            isLoading: isAcceptLoading,
            label: l10n.actionAccept,
            onPressed: onAccept,
          ),
        ),
      ],
    );
  }
}
