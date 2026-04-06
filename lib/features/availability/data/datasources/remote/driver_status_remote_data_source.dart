import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/availability/data/mappers/driver_status_mapper.dart';
import 'package:taxi_driver_app/features/availability/domain/entities/driver_status.dart';

abstract interface class DriverStatusRemoteDataSource {
  Future<void> setStatus({required DriverStatus status});
}

/// Calls the backend endpoint responsible for updating driver availability.
final class DriverStatusRemoteDataSourceImpl
    implements DriverStatusRemoteDataSource {
  DriverStatusRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<void> setStatus({required DriverStatus status}) async {
    await _apiClient.putVoid(
      '/api/admin/drivers/status',
      body: {
        'status': driverStatusToApi(status),
      },
    );
  }
}
