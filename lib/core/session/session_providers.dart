import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:taxi_driver_app/core/session/auth_session.dart';
import 'package:taxi_driver_app/core/session/auth_session_storage.dart';

final authSessionStorageProvider = Provider<AuthSessionStorage>((ref) {
  return AuthSessionStorage();
});

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  final storage = ref.watch(authSessionStorageProvider);
  return AuthSession(storage);
});
