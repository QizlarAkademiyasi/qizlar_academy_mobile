import 'dart:math';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart'
    show PackageInfo, SharedPreferences;
import 'package:watchdog/watchdog.dart';

/// Base URL of the watchdog-nest server — **without** a path. The package
/// appends `/ws/app` itself (see `WatchdogCloudClient._connect`), so passing
/// `wss://host/watchdog` here would produce `wss://host/watchdog/ws/app`.
const String kWatchdogServerUrl = String.fromEnvironment(
  'WATCHDOG_SERVER_URL',
  defaultValue: 'ws://localhost:8080',
);

const String kWatchdogClientApiKey = String.fromEnvironment(
  'WATCHDOG_CLIENT_API_KEY',
  defaultValue: 'change-client-key',
);

const String _deviceIdPrefsKey = 'watchdog_device_id';

/// Starts Watchdog in local + cloud mirror mode.
///
/// Call after `WidgetsFlutterBinding.ensureInitialized()` and before the DI
/// container is built, so `Watchdog.dioInterceptor` and the route observer
/// return the live runtime rather than their no-op fallbacks.
///
/// Never throws: Watchdog is enabled in every build, so a failure here must not
/// be able to stop the app from starting.
Future<void> initializeWatchdog({
  String serverUrl = kWatchdogServerUrl,
  String apiKey = kWatchdogClientApiKey,
  String appName = 'qizlar-academy',
}) async {
  try {
    await Watchdog.start(
      config: WatchdogConfig(
        enabled: true,
        global: false,
        cloud: WatchdogCloudConfig(
          serverUrl: serverUrl,
          apiKey: apiKey,
          appName: appName,
        ),
        device: await _resolveDevice(appName),
      ),
    );
  } catch (_) {
    // Swallowed on purpose — see the doc comment.
  }
}

/// Fills in the user identity once it is known (after login / profile load), so
/// the dashboard's device list and map label a pin with a person rather than
/// just a phone model.
void updateWatchdogUser({String? username, String? phoneNumber, String? email}) {
  try {
    Watchdog.updateUser(
      username: username,
      phoneNumber: phoneNumber,
      email: email,
    );
  } catch (_) {
    // Watchdog may not be running; identity is cosmetic.
  }
}

/// A [WatchdogDevice] carrying a **stable** `deviceId`.
///
/// This matters more than it looks: without one, `WatchdogRuntime` falls back to
/// a fresh UUID on every launch, so each app start would create a brand-new
/// cloud session and the server would accumulate one row per run.
Future<WatchdogDevice> _resolveDevice(String appName) async {
  String? deviceId;
  String? appVersion;

  try {
    final prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString(_deviceIdPrefsKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _generateDeviceId();
      await prefs.setString(_deviceIdPrefsKey, deviceId);
    }
  } catch (_) {
    // No persistence available — fall back to a per-run id.
    deviceId ??= _generateDeviceId();
  }

  try {
    final info = await PackageInfo.fromPlatform();
    appVersion = '${info.version}+${info.buildNumber}';
  } catch (_) {
    // Version is optional metadata.
  }

  return WatchdogDevice(
    deviceId: deviceId,
    appName: appName,
    appVersion: appVersion,
  );
}

String _generateDeviceId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
