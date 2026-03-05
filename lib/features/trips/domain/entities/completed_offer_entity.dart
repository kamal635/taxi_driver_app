final class CompletedOfferEntity {
  CompletedOfferEntity({
    required this.offerId,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  final String offerId;
  final String pickup;
  final String dropoff;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;
}
