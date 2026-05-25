import 'package:bawabat_al_saeq/features/availability/domain/entities/driver_status.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/driver_status_repository.dart';

/// Updates the driver's availability status on the backend.
final class SetDriverStatusUseCase {
  SetDriverStatusUseCase({required DriverStatusRepository repository})
    : _repository = repository;

  final DriverStatusRepository _repository;

  Future<void> call({required DriverStatus status}) {
    return _repository.setStatus(status: status);
  }
}
