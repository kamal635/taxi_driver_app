import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/set_password_usecase.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/sign_in_usecase.dart';

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

final setPasswordUseCaseProvider = Provider<SetPasswordUseCase>((ref) {
  return SetPasswordUseCase(ref.read(authRepositoryProvider));
});
