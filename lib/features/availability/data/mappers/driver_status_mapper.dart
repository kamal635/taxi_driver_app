import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';

String driverStatusToApi(DriverStatus status) {
  return switch (status) {
    DriverStatus.online => 'ONLINE',
    DriverStatus.offline => 'OFFLINE',
  };
}
