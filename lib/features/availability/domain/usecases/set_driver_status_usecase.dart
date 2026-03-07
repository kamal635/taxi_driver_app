import 'package:taxi_driver_app/features/availability/domain/entity/driver_status.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/driver_status_repository.dart';

final class SetDriverStatusUseCase {
  SetDriverStatusUseCase({required this.repo});

  final DriverStatusRepository repo;

  Future<void> call({required DriverStatus status}) {
    return repo.setStatus(status: status);
  }
}
