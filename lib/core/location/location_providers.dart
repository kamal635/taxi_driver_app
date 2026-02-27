import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/geolocator_location_service.dart';
import 'package:taxi_driver_app/core/location/location_service.dart';

final locationServiceProvider = Provider<LocationService>(
  (_) => GeolocatorLocationService(),
);
