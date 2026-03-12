import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/remote/driver_location_remote_datasource.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/driver_location_repository.dart';

final driverLocationRepositoryProvider = Provider<DriverLocationRepository>(
  (ref) {
    return DriverLocationRepositoryImpl(
      datasource: ref.read(driverLocationRemoteDatasourceProvider),
    );
  },
);

final class DriverLocationRepositoryImpl implements DriverLocationRepository {
  DriverLocationRepositoryImpl({
    required DriverLocationRemoteDatasource datasource,
  }) : _datasource = datasource;

  final DriverLocationRemoteDatasource _datasource;
  @override
  Future<void> updateLocation({
    required double lat,
    required double lon,
  }) async {
    await _datasource.updateLocation(lat: lat, lon: lon);
  }
}
