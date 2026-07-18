import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

typedef InternetAccessCheck = Future<bool> Function();

/// Ilova bo'ylab real internetga chiqish holatini kuzatadi.
///
/// [Connectivity] tarmoq interfeysi uzilishini darhol beradi, [InternetConnection]
/// esa Wi-Fi/mobile data mavjud bo'lsa ham internetga chiqish borligini tekshiradi.
class NetworkStatusService extends ChangeNotifier with WidgetsBindingObserver {
  NetworkStatusService({
    Stream<List<ConnectivityResult>>? connectivityChanges,
    Stream<InternetStatus>? internetStatusChanges,
    InternetAccessCheck? checkInternetAccess,
    Future<List<ConnectivityResult>> Function()? checkConnectivity,
  }) : _connectivityChanges =
           connectivityChanges ?? Connectivity().onConnectivityChanged,
       _internetStatusChanges =
           internetStatusChanges ?? InternetConnection().onStatusChange,
       _checkInternetAccess =
           checkInternetAccess ??
           (() => InternetConnection().hasInternetAccess),
       _checkConnectivity =
           checkConnectivity ?? Connectivity().checkConnectivity;

  final Stream<List<ConnectivityResult>> _connectivityChanges;
  final Stream<InternetStatus> _internetStatusChanges;
  final InternetAccessCheck _checkInternetAccess;
  final Future<List<ConnectivityResult>> Function() _checkConnectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetStatus>? _internetSubscription;
  bool _isOffline = false;
  bool _started = false;
  int _revision = 0;

  bool get isOffline => _isOffline;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _connectivitySubscription = _connectivityChanges.listen(
      _onConnectivityChanged,
      onError: _onMonitorError,
    );
    _internetSubscription = _internetStatusChanges.listen(
      _onInternetStatusChanged,
      onError: _onMonitorError,
    );
    unawaited(refresh());
  }

  Future<void> refresh() async {
    final revision = ++_revision;
    try {
      final connections = await _checkConnectivity();
      if (revision != _revision) return;
      if (_hasNoNetwork(connections)) {
        _setOffline(true);
        return;
      }
      final hasInternet = await _checkInternetAccess();
      if (revision == _revision) _setOffline(!hasInternet);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Network status refresh failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> connections) {
    ++_revision;
    if (_hasNoNetwork(connections)) {
      _setOffline(true);
      return;
    }
    unawaited(_confirmInternetAccess());
  }

  Future<void> _confirmInternetAccess() async {
    final revision = ++_revision;
    try {
      final hasInternet = await _checkInternetAccess();
      if (revision == _revision) _setOffline(!hasInternet);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Internet access check failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _onInternetStatusChanged(InternetStatus status) {
    ++_revision;
    _setOffline(status == InternetStatus.disconnected);
  }

  bool _hasNoNetwork(List<ConnectivityResult> connections) =>
      connections.isEmpty ||
      connections.every((result) => result == ConnectivityResult.none);

  void _setOffline(bool value) {
    if (_isOffline == value) return;
    _isOffline = value;
    AppLogger.i({'network_status': value ? 'offline' : 'online'});
    notifyListeners();
  }

  void _onMonitorError(Object error, StackTrace stackTrace) {
    AppLogger.e(
      'Network status monitor failed',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_connectivitySubscription?.cancel());
    unawaited(_internetSubscription?.cancel());
    super.dispose();
  }
}
