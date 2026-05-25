import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/completed_trip_time_formatter.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TripStopType {
  pickup,
  dropoff,
}

class CompletedTripCard extends StatelessWidget {
  const CompletedTripCard({
    required this.offer,
    super.key,
  });

  final CompletedOfferEntity offer;

  List<TripTimelineItemData> get _timelineItems {
    return [
      TripTimelineItemData(
        label: 'من',
        value: offer.pickup,
        type: TripStopType.pickup,
      ),
      if (offer.dropoff?.trim().isNotEmpty ?? false)
        TripTimelineItemData(
          label: 'إلى',
          value: offer.dropoff!.trim(),
          type: TripStopType.dropoff,
        ),
    ];
  }

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
            child: TripTimeline(items: _timelineItems),
          ),
          AppSpacing.w8,
          _CompletedTripMeta(offer: offer),
        ],
      ),
    );
  }
}

class _CompletedTripMeta extends StatelessWidget {
  const _CompletedTripMeta({
    required this.offer,
  });

  final CompletedOfferEntity offer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CompletedTripTimeFormatter.format(context, offer.updatedAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.subtitleSm.copyWith(
            color: AppColors.iconMuted,
            fontSize: 10.sp,
          ),
        ),
        AppSpacing.h12,
        Text(
          '${formatOrderPrice(offer.price)} ل.س',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.subtitleMd.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

@immutable
class TripTimelineItemData {
  const TripTimelineItemData({
    required this.label,
    required this.value,
    required this.type,
  });

  final String label;
  final String value;
  final TripStopType type;
}

class TripTimeline extends StatelessWidget {
  const TripTimeline({
    required this.items,
    super.key,
  });

  final List<TripTimelineItemData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: _TripTimelineDimensions.itemSpacing.h,
          ),
          child: TripTimelineTile(
            item: items[index],
            showConnector: index != items.length - 1,
          ),
        ),
      ),
    );
  }
}

class TripTimelineTile extends StatelessWidget {
  const TripTimelineTile({
    required this.item,
    required this.showConnector,
    super.key,
  });

  final TripTimelineItemData item;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final palette = TripStopPalette.fromType(item.type);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _TripTimelineDimensions.minTileHeight.h,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TripStopIndicator(
              palette: palette,
              showConnector: showConnector,
            ),
            AppSpacing.w4,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: _TripTimelineDimensions.textTopPadding.h,
                ),
                child: _TripTimelineText(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripStopIndicator extends StatelessWidget {
  const TripStopIndicator({
    required this.palette,
    required this.showConnector,
    super.key,
  });

  final TripStopPalette palette;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _TripTimelineDimensions.indicatorWidth.w,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: _TripTimelineDimensions.markerTopPadding.h,
            ),
            child: _TimelineMarker(palette: palette),
          ),
          if (showConnector)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Center(
                  child: CustomPaint(
                    painter: _DottedVerticalLinePainter(
                      color: AppColors.iconMuted.withValues(alpha: 0.45),
                    ),
                    child: SizedBox(
                      width: _TripTimelineDimensions.connectorWidth.w,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TripTimelineText extends StatelessWidget {
  const _TripTimelineText({
    required this.item,
  });

  final TripTimelineItemData item;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${item.label}: ',
            style: AppTypography.subtitleSm,
          ),
          TextSpan(
            text: item.value,
            style: AppTypography.bodySm.copyWith(fontSize: 10.sp),
          ),
        ],
      ),
      textAlign: TextAlign.right,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.palette,
  });

  final TripStopPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _TripTimelineDimensions.markerSize.r,
      height: _TripTimelineDimensions.markerSize.r,
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: _TripTimelineDimensions.innerDotSize.r,
        height: _TripTimelineDimensions.innerDotSize.r,
        decoration: BoxDecoration(
          color: palette.dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DottedVerticalLinePainter extends CustomPainter {
  const _DottedVerticalLinePainter({
    required this.color,
  });

  final Color color;

  static const double _dotDiameter = 2;
  static const double _gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const radius = _dotDiameter / 2;
    final centerX = size.width / 2;

    // const double topInset = 3;
    var currentY = radius;

    while (currentY <= size.height - radius) {
      canvas.drawCircle(
        Offset(centerX, currentY),
        radius,
        paint,
      );
      currentY += _dotDiameter + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedVerticalLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class TripStopPalette {
  const TripStopPalette({
    required this.dotColor,
    required this.backgroundColor,
  });

  factory TripStopPalette.fromType(TripStopType type) {
    switch (type) {
      case TripStopType.pickup:
        return TripStopPalette(
          dotColor: AppColors.info,
          backgroundColor: AppColors.info.withValues(alpha: 0.10),
        );
      case TripStopType.dropoff:
        return TripStopPalette(
          dotColor: AppColors.error,
          backgroundColor: AppColors.error.withValues(alpha: 0.10),
        );
    }
  }

  final Color dotColor;
  final Color backgroundColor;
}

class _TripTimelineDimensions {
  const _TripTimelineDimensions._();

  static const double indicatorWidth = 20;
  static const double markerSize = 12;
  static const double innerDotSize = 6;
  static const double connectorWidth = 2;
  static const double markerTopPadding = 2;
  static const double textTopPadding = 0;
  static const double connectorMinHeight = 12;
  static const double itemSpacing = 0;

  static const double minTileHeight =
      markerTopPadding + markerSize + connectorMinHeight;
}
