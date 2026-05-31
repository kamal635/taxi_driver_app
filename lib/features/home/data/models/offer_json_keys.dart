final class OfferJsonKeys {
  const OfferJsonKeys._();

  static const type = ['type', 'order_status'];
  static const offerId = ['orderId', 'offerId', 'id', 'order_id'];
  static const pickup = [
    'pickupText',
    'pickup',
    'pickup_address',
    'pickup_text',
  ];
  static const dropoff = [
    'dropoffText',
    'dropoff',
    'dropoff_address',
    'dropoff_text',
  ];
  static const price = ['price', 'fare', 'total', 'total_fare'];
  static const expiresAt = ['expiresAt', 'expires_at'];
  static const cooldownUntil = ['cooldownUntil', 'cooldown_until'];
  static const customerPhone = ['customerPhone', 'customer_phone', 'phone'];
  static const notes = ['note', 'notes'];
}
