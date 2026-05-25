import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:bawabat_al_saeq/features/trips/data/models/completed_offer_model.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Data model for the completed trips response.
final class CompletedOffersResultModel {
  CompletedOffersResultModel({
    required this.type,
    required this.period,
    required this.count,
    required this.totalProfits,
    required this.offers,
  });

  factory CompletedOffersResultModel.fromJson(Map<String, dynamic> json) {
    final offers = (json['orders'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CompletedOfferModel.fromJson)
        .toList();

    return CompletedOffersResultModel(
      type: JsonReader.requireString(json, 'type'),
      period: completedPeriodFromJson(json['period']),
      count: (json['count'] as num?)?.toInt() ?? offers.length,
      totalProfits: JsonReader.requireString(json, 'total_profits'),
      offers: offers,
    );
  }

  final String type;
  final CompletedPeriod period;
  final int count;
  final String totalProfits;
  final List<CompletedOfferModel> offers;

  CompletedOffersResultEntity toEntity() {
    return CompletedOffersResultEntity(
      type: type,
      period: period,
      count: count,
      totalProfits: totalProfits,
      offers: offers.map((offer) => offer.toEntity()).toList(),
    );
  }
}
