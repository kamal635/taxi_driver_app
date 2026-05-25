import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';

/// Maps domain driver status values to backend API values.
String driverStatusToApi(DriverStatus status) {
  return switch (status) {
    DriverStatus.online => 'ONLINE',
    DriverStatus.offline => 'OFFLINE',
  };
}
