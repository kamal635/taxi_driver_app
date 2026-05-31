/// Typed event emitted when the native Android driver service stops.
final class DriverBackgroundServiceEvent {
  const DriverBackgroundServiceEvent({
    required this.reason,
  });

  final String reason;
}

/// Typed event emitted when the native Android service receives a new offer.
final class DriverBackgroundOfferEvent {
  const DriverBackgroundOfferEvent({
    required this.payloadJson,
  });

  final String payloadJson;
}

/// Typed event emitted when the driver opens an offer notification.
final class DriverOfferNotificationOpenEvent {
  const DriverOfferNotificationOpenEvent({
    required this.offerId,
    required this.payloadJson,
  });

  final String? offerId;
  final String? payloadJson;
}

/// Typed event emitted when the native layer asks the app to force logout.
final class DriverForceLogoutEvent {
  const DriverForceLogoutEvent({
    required this.reason,
    required this.payloadJson,
  });

  final String reason;
  final String? payloadJson;
}
