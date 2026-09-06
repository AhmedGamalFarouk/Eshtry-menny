import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NetworkStatus { connected, disconnected }

class NetworkMonitorCubit extends Cubit<NetworkStatus> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkMonitorCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(NetworkStatus.connected) {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
    } catch (_) {
      emit(NetworkStatus.connected);
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final isDisconnected =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (isDisconnected) {
      emit(NetworkStatus.disconnected);
    } else {
      emit(NetworkStatus.connected);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
