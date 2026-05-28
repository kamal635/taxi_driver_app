import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the active pending offer and validates that it is still actionable.
NewOfferEntity? readActivePendingOffer({
  required Ref ref,
  required String expectedOfferId,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  final pendingOfferState = ref.read(newOfferControllerProvider);
  final pendingOffer = pendingOfferState.asData?.value.currentOffer;

  if (pendingOffer == null) {
    onError(
      StateError('This offer is no longer available.'),
      StackTrace.current,
    );
    return null;
  }

  if (pendingOffer.offerId != expectedOfferId) {
    onError(
      StateError('This offer is no longer the active pending offer.'),
      StackTrace.current,
    );
    return null;
  }

  if (!pendingOffer.expiresAt.isAfter(DateTime.now())) {
    ref.read(newOfferControllerProvider.notifier).clearCurrent();

    onError(
      StateError('This offer has expired.'),
      StackTrace.current,
    );
    return null;
  }

  return pendingOffer;
}
