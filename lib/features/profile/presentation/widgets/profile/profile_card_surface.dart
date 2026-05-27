import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

/// Backward-compatible profile card wrapper.
///
/// New code should prefer [AppCardSurface] directly. This wrapper is kept so
/// older profile imports continue to work while all card styling stays shared.
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
