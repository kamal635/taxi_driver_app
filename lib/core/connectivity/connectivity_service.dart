import 'package:bawabat_al_saeq/core/connectivity/connectivity_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Watches device network connectivity changes.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<AppConnectivityStatus> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    return _mapResults(results);
  }

  Stream<AppConnectivityStatus> watchStatus() async* {
    yield await checkStatus();

    yield* _connectivity.onConnectivityChanged.map(_mapResults).distinct();
  }

  AppConnectivityStatus _mapResults(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    return hasConnection
        ? AppConnectivityStatus.connected
        : AppConnectivityStatus.disconnected;
  }
}
