import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/network/network_status_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'shows offline immediately when all network interfaces disappear',
    () async {
      final connectivity = StreamController<List<ConnectivityResult>>();
      final internet = StreamController<InternetStatus>();
      final service = NetworkStatusService(
        connectivityChanges: connectivity.stream,
        internetStatusChanges: internet.stream,
        checkConnectivity: () async => [ConnectivityResult.wifi],
        checkInternetAccess: () async => true,
      )..start();
      await pumpEventQueue();

      connectivity.add([ConnectivityResult.none]);
      await pumpEventQueue();

      expect(service.isOffline, isTrue);
      service.dispose();
      await connectivity.close();
      await internet.close();
    },
  );

  test('keeps offline screen until real internet access is restored', () async {
    final connectivity = StreamController<List<ConnectivityResult>>();
    final internet = StreamController<InternetStatus>();
    var hasInternet = false;
    final service = NetworkStatusService(
      connectivityChanges: connectivity.stream,
      internetStatusChanges: internet.stream,
      checkConnectivity: () async => [ConnectivityResult.wifi],
      checkInternetAccess: () async => hasInternet,
    )..start();
    await pumpEventQueue();
    expect(service.isOffline, isTrue);

    connectivity.add([ConnectivityResult.wifi]);
    await pumpEventQueue();
    expect(service.isOffline, isTrue);

    hasInternet = true;
    internet.add(InternetStatus.connected);
    await pumpEventQueue();
    expect(service.isOffline, isFalse);

    service.dispose();
    await connectivity.close();
    await internet.close();
  });
}
