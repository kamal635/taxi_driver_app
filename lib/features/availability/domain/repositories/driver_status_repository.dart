import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';

abstract interface class DriverStatusRepository {
  Future<void> setStatus({required DriverStatus status});
}
