import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final List<VoidCallback> _retryCallbacks = [];

  void _init() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // Internet is back — run all retry callbacks
        for (final callback in _retryCallbacks) {
          callback();
        }
      }
    });
  }

  void registerRetryCallback(VoidCallback callback) {
    if (!_retryCallbacks.contains(callback)) {
      _retryCallbacks.add(callback);
    }
  }

  void unregisterRetryCallback(VoidCallback callback) {
    _retryCallbacks.remove(callback);
  }
}
