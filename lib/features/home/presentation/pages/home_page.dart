import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_order_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_offer_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _listenActionErrors(BuildContext context, WidgetRef ref) {
    // new offer.
    ref
      ..listen(
        newOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null) return;
          if (previous == next) return;

          final msg = failureToUserMessage(next, l10n: context.l10n);
          context.showAppSnack(msg, type: AppSnackType.error);
        },
      )
      // Accept errors.
      ..listen(
        accepteOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null) return;
          if (identical(previous, next)) return;

          final msg = failureToUserMessage(next.toString(), l10n: context.l10n);
          context.showAppSnack(msg, type: AppSnackType.error);
        },
      )
      // Decline errors.
      ..listen(
        declineOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null) return;
          if (identical(previous, next)) return;

          final msg = failureToUserMessage(next.toString(), l10n: context.l10n);
          context.showAppSnack(msg, type: AppSnackType.error);
        },
      )
      // Done/complete errors.
      ..listen(
        completeOrderControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null) return;
          if (identical(previous, next)) return;

          final msg = failureToUserMessage(next.toString(), l10n: context.l10n);
          context.showAppSnack(msg, type: AppSnackType.error);
        },
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenActionErrors(context, ref);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          AppSpacing.h16,
          const Expanded(
            child: _HomeScrollBody(),
          ),
        ],
      ),
    );
  }
}

class _HomeScrollBody extends StatelessWidget {
  const _HomeScrollBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const HomeOfferSection(),
          ),
        );
      },
    );
  }
}
