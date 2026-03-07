import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

class NewOfferActionsRow extends StatelessWidget {
  const NewOfferActionsRow({
    required this.enabled,
    required this.isLoading,
    required this.acceptLabel,
    required this.rejectLabel,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  final bool enabled;
  final bool isLoading;
  final String acceptLabel;
  final String rejectLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || !enabled;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            labelColor: AppColors.error,
            borderColor: AppColors.error,
            backgroundColor: Colors.transparent,
            isLoading: isLoading,
            onPressed: disabled ? null : onReject,
            label: rejectLabel,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: AppButton(
            isLoading: isLoading,
            onPressed: disabled ? null : onAccept,
            label: acceptLabel,
          ),
        ),
      ],
    );
  }
}
