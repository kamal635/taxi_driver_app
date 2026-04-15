import 'package:flutter/material.dart';
import 'package:taxi_driver_app/shared/presentation/widgets/surfaces/app_card_surface.dart';

class ProfileCardSurface extends StatelessWidget {
  const ProfileCardSurface({
    required this.child,
    this.padding,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      padding: padding,
      child: child,
    );
  }
}
