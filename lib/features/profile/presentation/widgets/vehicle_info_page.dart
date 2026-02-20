import 'package:flutter/material.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/vehicle_info_card.dart';

class VehicleModel {
  const VehicleModel({
    required this.plateNumber,
    required this.taxiLanternNumber,
    required this.model,
    required this.type,
  });

  final String plateNumber;
  final String taxiLanternNumber;
  final String model;
  final VehicleType type;
}

enum VehicleType { public, private }

extension VehicleTypeX on VehicleType {
  String get label {
    switch (this) {
      case VehicleType.public:
        return 'Public';
      case VehicleType.private:
        return 'Private';
    }
  }
}

class VehicleInfoPage extends StatelessWidget {
  const VehicleInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const vehicle = VehicleModel(
      plateNumber: '123456',
      taxiLanternNumber: '7890',
      model: 'Toyota 2022',
      type: VehicleType.public,
    );

    return AppOverlayScaffold(
      title: l10n.vehicleTitle,
      child: const VehicleCard(vehicle: vehicle),
    );
  }
}
