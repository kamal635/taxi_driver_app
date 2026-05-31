import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/data/models/current_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/data/models/pending_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/current_and_pending_offer_entity.dart';

/// Combined payload that may contain the active current offer and/or a pending
/// incoming offer.
final class CurrentAndPendingOfferModel {
  const CurrentAndPendingOfferModel({
    required this.currentOffer,
    required this.pendingOffer,
  });

  factory CurrentAndPendingOfferModel.fromJson(Map<String, dynamic> json) {
    final currentJson = JsonReader.optionalMap(json, 'currentOrder');
    final pendingJson = JsonReader.optionalMap(json, 'pendingOffer');

    return CurrentAndPendingOfferModel(
      currentOffer: currentJson == null
          ? null
          : CurrentOfferModel.fromJson(currentJson),
      pendingOffer: pendingJson == null
          ? null
          : PendingOfferModel.fromJson(pendingJson),
    );
  }

  final CurrentOfferModel? currentOffer;
  final PendingOfferModel? pendingOffer;

  CurrentAndPendingOfferEntity toEntity() {
    return CurrentAndPendingOfferEntity(
      currentOffer: currentOffer?.toEntity(),
      pendingOffer: pendingOffer?.toEntity(),
    );
  }
}
