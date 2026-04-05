import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_offer_section.dart';

/// Home page that shows the current offer state for the driver.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              AppSpacing.h16,
              const Expanded(child: _HomeScrollBody()),
            ],
          ),
        ),
        const _HomeActionErrorListeners(),
      ],
    );
  }
}

/// Invisible widget used only to centralize action error listeners.
class _HomeActionErrorListeners extends ConsumerWidget {
  const _HomeActionErrorListeners();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen<String?>(
        newOfferControllerProvider.select(
          (state) => state.asData?.value.errorMessage,
        ),
        (previous, next) {
          if (next == null || next.isEmpty || previous == next) return;

          final message = failureToUserMessage(next, l10n: context.l10n);
          context.showAppSnack(message, type: AppSnackType.error);
        },
      )
      ..listen<Object?>(
        acceptOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null || identical(previous, next)) return;

          final message = failureToUserMessage(
            next.toString(),
            l10n: context.l10n,
          );
          context.showAppSnack(message, type: AppSnackType.error);
        },
      )
      ..listen<Object?>(
        declineOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null || identical(previous, next)) return;

          final message = failureToUserMessage(
            next.toString(),
            l10n: context.l10n,
          );
          context.showAppSnack(message, type: AppSnackType.error);
        },
      )
      ..listen<Object?>(
        completeOfferControllerProvider.select((state) => state.error),
        (previous, next) {
          if (next == null || identical(previous, next)) return;

          final message = failureToUserMessage(
            next.toString(),
            l10n: context.l10n,
          );
          context.showAppSnack(message, type: AppSnackType.error);
        },
      );

    return const SizedBox.shrink();
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
