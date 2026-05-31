import 'dart:async';

import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

final class PendingOfferExpiryScheduler {
  Timer? _timer;

  void schedule({
    required NewOfferEntity offer,
    required void Function(NewOfferEntity offer) onExpired,
  }) {
    cancel();

    final remaining = offer.expiresAt.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      onExpired(offer);
      return;
    }

    _timer = Timer(remaining, () => onExpired(offer));
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
