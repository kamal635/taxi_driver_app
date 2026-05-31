import 'package:bawabat_al_saeq/core/connectivity/connectivity_service.dart';
import 'package:bawabat_al_saeq/core/connectivity/connectivity_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectivityStatusProvider = StreamProvider<AppConnectivityStatus>((ref) {
  return ref.watch(connectivityServiceProvider).watchStatus();
});
