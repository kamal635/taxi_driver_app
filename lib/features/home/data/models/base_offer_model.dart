/// Base structure shared by parsed offer models.
abstract class OfferModel {
  const OfferModel({
    required this.type,
    required this.offerId,
    required this.pickup,
    required this.price,
    this.dropoff,
    this.notes,
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
  final String? notes;
  final String price;
}
