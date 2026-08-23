import 'package:flutter/widgets.dart';
import 'package:watchdog/watchdog.dart';

const String _defaultServerUrl = String.fromEnvironment(
  'WATCHDOG_SERVER_URL',
  defaultValue: 'ws://localhost:8080/watchdog',
);

const String _defaultApiKey = String.fromEnvironment(
  'WATCHDOG_CLIENT_API_KEY',
  defaultValue: 'change-client-key',
);

Future<void> initializeWatchdog({
  String serverUrl = _defaultServerUrl,
  String apiKey = _defaultApiKey,
  String appName = 'qizlar-academy',
  WatchdogDevice? device,
}) {
  return Watchdog.start(
    config: WatchdogConfig(
      enabled: true,
      global: false,
      cloud: WatchdogCloudConfig(
        serverUrl: serverUrl,
        apiKey: apiKey,
        appName: appName,
      ),
      device: device,
    ),
  );
}

List<NavigatorObserver> watchdogNavigatorObservers([
  List<NavigatorObserver> existing = const [],
]) {
  return [
    ...existing,
    Watchdog.routeObserver,
  ];
}
