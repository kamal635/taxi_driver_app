import 'package:taxi_driver_app/features/availability/data/datasources/driver_status_remote_datasource.dart';
import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/driver_status_repository.dart';

final class DriverStatusRepositoryImpl implements DriverStatusRepository {
  DriverStatusRepositoryImpl({required this.remote});

  final DriverStatusRemoteDataSource remote;

  @override
  Future<void> setStatus({required DriverStatus status}) {
    return remote.setStatus(status: status);
  }
}
