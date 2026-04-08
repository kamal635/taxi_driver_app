import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/utils/price_formatter.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:taxi_driver_app/features/trips/presentation/formatters/completed_trip_time_formatter.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_card_surface.dart';

enum TripsTimelineItemType {
  from,
  to,
}

class CompletedTripCard extends StatelessWidget {
  const CompletedTripCard({required this.offer, super.key});

  final CompletedOfferEntity offer;

  @override
  Widget build(BuildContext context) {
    return TripsCardSurface(
      child: Row(
        children: [
          Icon(
            AppIcons.history,
            size: 28.r,
            color: AppColors.iconMuted,
          ),
          AppSpacing.w4,
          Expanded(
            child: TripsTimeline(
              items: [
                TripsTimelineItemData(
                  title: offer.pickup,
                  where: 'من',
                  type: TripsTimelineItemType.from,
                ),

                TripsTimelineItemData(
                  title: offer.dropoff ?? '',
                  where: 'إلى',
                  type: TripsTimelineItemType.to,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                CompletedTripTimeFormatter.format(context, offer.updatedAt),
                style: AppTypography.subtitleSm.copyWith(
                  color: AppColors.iconMuted,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.h12,
              Text(
                'SYP ${formatOrderPrice(offer.price)}',
                style: AppTypography.subtitleMd.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TripsTimelineItemData {
  const TripsTimelineItemData({
    required this.title,
    required this.where,
    required this.type,
    this.subtitle,
  });

  final String title;
  final String where;
  final String? subtitle;
  final TripsTimelineItemType type;
}

class TripsTimeline extends StatelessWidget {
  const TripsTimeline({
    required this.items,
    super.key,
  });

  final List<TripsTimelineItemData> items;

  @override
  Widget build(BuildContext context) {
    // space between marker and subtitle + space between title and subtitle
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        items.length,
        (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 1),
            child: _TripsTimelineTile(
              item: item,
              isLast: isLast,
            ),
          );
        },
      ),
    );
  }
}

class _TripsTimelineTile extends StatelessWidget {
  const _TripsTimelineTile({
    required this.item,
    required this.isLast,
  });

  final TripsTimelineItemData item;
  final bool isLast;

  static const double _minConnectorHeight = 12;
  static const double _connectorTopOffset = 14;
  static const double _minTileHeight =
      _connectorTopOffset + _minConnectorHeight;

  @override
  Widget build(BuildContext context) {
    final palette = _TimelinePalette.fromType(item.type);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: _minTileHeight,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 20.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!isLast)
                    const Positioned.fill(
                      top: _connectorTopOffset,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _DottedVerticalConnector(),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: _TimelineMarker(palette: palette),
                  ),
                ],
              ),
            ),
            AppSpacing.w4,
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${item.where}: ',
                        style: AppTypography.subtitleSm,
                      ),
                      TextSpan(
                        text: item.title,
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.palette,
  });

  final _TimelinePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.r,
      height: 12.r,
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 6.r,
        height: 6.r,
        decoration: BoxDecoration(
          color: palette.dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DottedVerticalConnector extends StatelessWidget {
  const _DottedVerticalConnector();

  static const double minHeight = 12;
  static const double _dotSize = 2;
  static const double _gap = 1;
  static const int _minDots = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rawHeight = constraints.maxHeight;

        if (!rawHeight.isFinite || rawHeight <= 0) {
          return const SizedBox.shrink();
        }

        final height = rawHeight < minHeight ? minHeight : rawHeight;

        final dotCount = ((height + _gap) / (_dotSize + _gap)).floor().clamp(
          _minDots,
          100,
        );

        return SizedBox(
          width: _dotSize,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dotCount,
              (_) => Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: AppColors.iconMuted.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TimelinePalette {
  const _TimelinePalette({
    required this.dotColor,
    required this.backgroundColor,
  });

  factory _TimelinePalette.fromType(TripsTimelineItemType type) {
    switch (type) {
      case TripsTimelineItemType.from:
        return _TimelinePalette(
          dotColor: AppColors.info,
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
        );

      case TripsTimelineItemType.to:
        return _TimelinePalette(
          dotColor: AppColors.error,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
        );
    }
  }

  final Color dotColor;
  final Color backgroundColor;
}
