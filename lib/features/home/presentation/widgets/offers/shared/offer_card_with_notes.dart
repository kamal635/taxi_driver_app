import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_notes_card.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

class OfferCardWithNotes extends StatelessWidget {
  const OfferCardWithNotes({
    required this.child,
    this.notes,
    super.key,
  });

  final Widget child;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    final resolvedNotes = notes?.trim();
    final hasNotes = resolvedNotes != null && resolvedNotes.isNotEmpty;

    return Column(
      children: [
        AppCardSurface(child: child),
        if (hasNotes) OfferNotesCard(notes: resolvedNotes),
        AppSpacing.h32,
      ],
    );
  }
}
