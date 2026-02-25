import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/set_password_usecase.dart';
import 'package:taxi_driver_app/features/auth/presentation/controllers/auth_usecases_providers.dart';

final setupPasswordControllerProvider =
    AsyncNotifierProvider<SetupPasswordController, String?>(
      SetupPasswordController.new,
    );

class SetupPasswordController extends AsyncNotifier<String?> {
  late final SetPasswordUseCase _setPassword;

  @override
  Future<String?> build() async {
    _setPassword = ref.read(setPasswordUseCaseProvider);
    return null;
  }

  Future<void> submit({
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      final msg = await _setPassword(token: token, newPassword: newPassword);
      state = AsyncData(msg);
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void reset() => state = const AsyncData(null);
}
