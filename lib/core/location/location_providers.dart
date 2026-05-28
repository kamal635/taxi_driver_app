import 'package:bawabat_al_saeq/core/location/geolocator_location_service.dart';
import 'package:bawabat_al_saeq/core/location/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = Provider<LocationService>(
  (_) => GeolocatorLocationService(),
);
