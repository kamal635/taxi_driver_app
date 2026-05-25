import 'package:bawabat_al_saeq/core/session/auth_session_storage.dart';
import 'package:bawabat_al_saeq/core/session/models/auth_session_snapshot.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authSessionStorageProvider = Provider<AuthSessionStorage>((ref) {
  return AuthSessionStorage();
});

final authSessionProvider = ChangeNotifierProvider<AuthSession>((ref) {
  return AuthSession(ref.watch(authSessionStorageProvider));
});

final Provider<AuthSessionSnapshot> authSessionSnapshotProvider = Provider((
  ref,
) {
  return ref.watch(authSessionProvider).snapshot;
});
