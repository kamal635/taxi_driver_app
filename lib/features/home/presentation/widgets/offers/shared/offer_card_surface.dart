import 'package:flutter/material.dart';
import 'package:taxi_driver_app/shared/presentation/widgets/surfaces/app_card_surface.dart';

class OfferCardSurface extends StatelessWidget {
  const OfferCardSurface({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(child: child);
  }
}
