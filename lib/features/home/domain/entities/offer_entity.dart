sealed class OfferEntity {
  OfferEntity({
    required this.type,
    required this.offerId,
    required this.pickup,
    required this.price,
    this.dropoff,
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
  final String price;
}

final class NewOfferEntity extends OfferEntity {
  NewOfferEntity({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    super.dropoff,
  });
}

final class OfferAcceptedEntity extends OfferEntity {
  OfferAcceptedEntity({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    super.dropoff,
    this.notes,
  });

  final String customerPhone;
  final String? notes;
}
