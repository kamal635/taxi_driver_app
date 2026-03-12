import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';

final driverLocationRemoteDatasourceProvider =
    Provider<DriverLocationRemoteDatasource>(
      (ref) {
        return DriverLocationRemoteDatasource(
          apiClient: ref.read(apiClientProvider),
        );
      },
    );

final class DriverLocationRemoteDatasource {
  DriverLocationRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<void> updateLocation({
    required double lat,
    required double lon,
  }) async {
    await _apiClient.putVoid(
      '/api/admin/drivers/location',
      body: {
        'lat': lat,
        'lon': lon,
      },
    );
  }
}
