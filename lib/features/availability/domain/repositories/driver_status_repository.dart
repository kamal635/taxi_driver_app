import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';

abstract interface class DriverStatusRepository {
  Future<void> setStatus({required DriverStatus status});
}
