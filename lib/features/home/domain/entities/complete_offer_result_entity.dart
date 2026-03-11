import 'package:flutter/foundation.dart';

@immutable
final class CompleteOfferResultEntity {
  const CompleteOfferResultEntity({
    required this.type,
    required this.message,
    required this.offerId,
  });

  final String type;
  final String message;
  final String offerId;
}
