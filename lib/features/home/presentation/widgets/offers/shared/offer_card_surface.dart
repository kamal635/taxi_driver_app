import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

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
