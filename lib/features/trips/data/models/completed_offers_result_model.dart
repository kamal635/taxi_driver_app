import 'package:taxi_driver_app/core/utils/json_reader.dart';
import 'package:taxi_driver_app/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:taxi_driver_app/features/trips/data/models/completed_offer_model.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

final class CompletedOffersResultModel {
  CompletedOffersResultModel({
    required this.type,
    required this.period,
    required this.count,
    required this.totalProfits,
    required this.offers,
  });

  factory CompletedOffersResultModel.fromJson(Map<String, dynamic> json) {
    final list = (json['orders'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CompletedOfferModel.fromJson)
        .toList();

    return CompletedOffersResultModel(
      type: JsonReader.requireString(json, 'type'),
      period: completedPeriodFromJson(json['period']),
      count: (json['count'] as num?)?.toInt() ?? list.length,
      totalProfits: JsonReader.requireString(json, 'total_profits'),
      offers: list,
    );
  }

  final String type;
  final CompletedPeriod period;
  final int count;
  final String totalProfits;
  final List<CompletedOfferModel> offers;

  CompletedOffersResultEntity toEntity() {
    final list = offers.map((e) => e.toEntity()).toList();

    return CompletedOffersResultEntity(
      type: type,
      period: period,
      count: count,
      totalProfits: totalProfits,
      offers: list,
    );
  }
}
