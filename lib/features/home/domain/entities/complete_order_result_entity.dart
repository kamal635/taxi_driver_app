import 'package:flutter/foundation.dart';

@immutable
final class CompleteOrderResultEntity {
  const CompleteOrderResultEntity({
    required this.type,
    required this.message,
    required this.orderId,
  });

  final String type;
  final String message;
  final String orderId;
}
