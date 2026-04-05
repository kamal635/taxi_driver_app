import 'package:taxi_driver_app/features/availability/data/datasources/remote/driver_status_remote_data_source.dart';
import 'package:taxi_driver_app/features/availability/domain/entities/driver_status.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/driver_status_repository.dart';

/// Default implementation of [DriverStatusRepository].
final class DriverStatusRepositoryImpl implements DriverStatusRepository {
  DriverStatusRepositoryImpl({
    required DriverStatusRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final DriverStatusRemoteDataSource _remoteDataSource;

  @override
  Future<void> setStatus({required DriverStatus status}) {
    return _remoteDataSource.setStatus(status: status);
  }
}
