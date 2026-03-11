import 'package:taxi_driver_app/features/home/domain/entities/complete_offer_result_entity.dart';

final class CompleteOfferResponseModel {
  const CompleteOfferResponseModel({
    required this.type,
    required this.message,
    required this.offerId,
  });

  factory CompleteOfferResponseModel.fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString().trim();
    final message = json['message']?.toString().trim();
    final offerId = json['orderId']?.toString().trim();

    if (type == null || type.isEmpty) {
      throw const FormatException('Missing type');
    }
    if (message == null || message.isEmpty) {
      throw const FormatException('Missing message');
    }
    if (offerId == null || offerId.isEmpty) {
      throw const FormatException('Missing orderId');
    }

    return CompleteOfferResponseModel(
      type: type,
      message: message,
      offerId: offerId,
    );
  }

  final String type;
  final String message;
  final String offerId;

  CompleteOfferResultEntity toEntity() {
    return CompleteOfferResultEntity(
      type: type,
      message: message,
      offerId: offerId,
    );
  }
}
