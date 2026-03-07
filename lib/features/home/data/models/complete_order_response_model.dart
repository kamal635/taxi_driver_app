import 'package:taxi_driver_app/features/home/domain/entities/complete_order_result_entity.dart';

final class CompleteOrderResponseModel {
  const CompleteOrderResponseModel({
    required this.type,
    required this.message,
    required this.orderId,
  });

  factory CompleteOrderResponseModel.fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString().trim();
    final message = json['message']?.toString().trim();
    final orderId = json['orderId']?.toString().trim();

    if (type == null || type.isEmpty) {
      throw const FormatException('Missing type');
    }
    if (message == null || message.isEmpty) {
      throw const FormatException('Missing message');
    }
    if (orderId == null || orderId.isEmpty) {
      throw const FormatException('Missing orderId');
    }

    return CompleteOrderResponseModel(
      type: type,
      message: message,
      orderId: orderId,
    );
  }

  final String type;
  final String message;
  final String orderId;

  CompleteOrderResultEntity toEntity() {
    return CompleteOrderResultEntity(
      type: type,
      message: message,
      orderId: orderId,
    );
  }
}
