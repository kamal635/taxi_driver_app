import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/availability/data/mappers/driver_status_mapper.dart';
import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';

abstract interface class DriverStatusRemoteDataSource {
  Future<void> setStatus({required DriverStatus status});
}

final class DriverStatusRemoteDataSourceImpl
    implements DriverStatusRemoteDataSource {
  DriverStatusRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> setStatus({required DriverStatus status}) async {
    // If your backend is /admin/drivers/status without /api, change path here.
    await apiClient.putVoid(
      '/api/admin/drivers/status',
      body: {'status': driverStatusToApi(status)},
    );
  }
}
