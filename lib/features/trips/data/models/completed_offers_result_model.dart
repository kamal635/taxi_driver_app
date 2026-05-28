import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:bawabat_al_saeq/features/trips/data/models/completed_offer_model.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Data model for the completed trips response.
final class CompletedOffersResultModel {
  const CompletedOffersResultModel({
    required this.type,
    required this.period,
    required this.count,
    required this.totalProfits,
    required this.offers,
  });

  factory CompletedOffersResultModel.fromJson(Map<String, dynamic> json) {
    final payload = _extractPayload(json);
    final offers = _readOffers(payload);

    return CompletedOffersResultModel(
      type:
          JsonReader.optionalAnyString(payload, const ['type', 'status']) ??
          'completed',
      period: completedPeriodFromJson(payload['period']),
      count: JsonReader.optionalInt(payload, 'count') ?? offers.length,
      totalProfits:
          JsonReader.optionalAnyString(payload, _totalProfitsKeys) ?? '0',
      offers: offers,
    );
  }

  static const List<String> _totalProfitsKeys = [
    'total_profits',
    'totalProfits',
    'total_profit',
    'totalProfit',
    'earnings',
    'total_earnings',
    'totalEarnings',
  ];

  static Map<String, dynamic> _extractPayload(Map<String, dynamic> json) {
    return JsonReader.optionalMap(json, 'data') ??
        JsonReader.optionalMap(json, 'result') ??
        json;
  }

  static List<CompletedOfferModel> _readOffers(Map<String, dynamic> json) {
    for (final key in const ['orders', 'offers', 'trips', 'items', 'data']) {
      final items = JsonReader.optionalMapList(json, key);
      if (items.isEmpty) continue;

      return items.map(CompletedOfferModel.fromJson).toList(growable: false);
    }

    return const [];
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
      offers: offers.map((offer) => offer.toEntity()).toList(growable: false),
    );
  }
}
