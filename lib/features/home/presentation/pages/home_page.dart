import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_order_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_card_surface.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_offers_section.dart';

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
            child: const HomeOffersSection(),
          ),
        );
      },
    );
  }
}

class HomeOffersSection1 extends StatelessWidget {
  const HomeOffersSection1({super.key});

  @override
  Widget build(BuildContext context) {
    return OfferCardSurface(
      child: Column(
        children: [
          const HomeHeaderOfferCard(),
          AppSpacing.h18,
          const RouteStopsExample(),
        ],
      ),
    );
  }
}

class HomeHeaderOfferCard extends StatelessWidget {
  const HomeHeaderOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                'NEW OFFER',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.info,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.errorBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                children: [
                  Icon(AppIcons.timer, size: 18.r, color: AppColors.error),
                  AppSpacing.w4,
                  Text(
                    'Expires in 00:42',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.h18,
        Text('TOTAL FARE', style: AppTypography.subtitleSm),
        AppSpacing.h4,
        Text('10,000.00 SYP', style: AppTypography.titleMd),
      ],
    );
  }
}

class RouteStopsExample extends StatelessWidget {
  const RouteStopsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final stops = [
      const RouteStopData(
        type: 'PICKUP',
        title: 'Downtown Central Station, Gate 4',
        color: Color(0xFF3B82F6),
      ),
      const RouteStopData(
        type: 'DROPOFF',
        title: 'Al-Hamra Luxury Residence, Tower B',
        color: Color(0xFF22C55E),
      ),
    ];

    return RouteStopsList(stops: stops);
  }
}

class RouteStopsList extends StatelessWidget {
  const RouteStopsList({
    required this.stops,
    super.key,
  });

  final List<RouteStopData> stops;

  @override
  Widget build(BuildContext context) {
    const lineLeft = 10.0;

    return Stack(
      children: [
        // Vertical line behind all items
        Positioned(
          left: lineLeft,
          top: 10,
          bottom: 10,
          child: Container(
            width: 2,
            color: AppColors.border,
          ),
        ),

        Column(
          children: List.generate(stops.length, (index) {
            final stop = stops[index];
            final isLast = index == stops.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: RouteStopTile(stop: stop),
            );
          }),
        ),
      ],
    );
  }
}

class RouteStopTile extends StatelessWidget {
  const RouteStopTile({
    required this.stop,
    super.key,
  });

  final RouteStopData stop;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot area
        SizedBox(
          width: 20,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: stop.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: stop.color.withValues(alpha: 0.18),
                  width: 4,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Text area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stop.type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stop.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RouteStopData {
  const RouteStopData({
    required this.type,
    required this.title,
    required this.color,
  });

  final String type;
  final String title;
  final Color color;
}

// class TimeRemainingBar extends StatelessWidget {
//   const TimeRemainingBar({
//     required this.title,
//     required this.remaining,
//     required this.total,
//     super.key,
//   });

//   final String title;
//   final Duration remaining;
//   final Duration total;

//   String _mmss(Duration d) {
//     final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalMs = total.inMilliseconds;
//     final remainingMs = remaining.inMilliseconds.clamp(0, totalMs);
//     final progress = totalMs == 0 ? 0.0 : remainingMs / totalMs;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//             ),
//             Text(
//               _mmss(remaining),
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w800,
//                 color: Color(0xFFF97316),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(999),
//           child: LinearProgressIndicator(
//             value: progress,
//             minHeight: 10,
//             backgroundColor: const Color(0xFFE5E7EB),
//             valueColor: const AlwaysStoppedAnimation(Color(0xFFF97316)),
//           ),
//         ),
//       ],
//     );
//   }
// }
