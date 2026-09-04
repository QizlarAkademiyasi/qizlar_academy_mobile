import 'dart:math';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart'
    show PackageInfo, SharedPreferences;
import 'package:watchdog/watchdog.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Base URL of the watchdog-nest server — **without** a path. The package
/// appends `/ws/app` itself (see `WatchdogCloudClient._connect`), so passing
/// `wss://host/watchdog` here would produce `wss://host/watchdog/ws/app`.
///
/// Defaults to the deployed server so a plain `flutter run` reports without any
/// extra flags. `--dart-define-from-file=build.json` still overrides it, which
/// is how you point a build at a local server or a different environment.
///
/// Never give this a `localhost` fallback: that is a valid URL, so it passes
/// every check and the app then dials a port on the phone itself forever.
const String kWatchdogServerUrl = String.fromEnvironment(
  'WATCHDOG_SERVER_URL',
  defaultValue: 'wss://log-api.roziboyevdev.uz',
);

/// Must match `WATCHDOG_CLIENT_API_KEY` in the server's `.env`.
///
/// Baked in deliberately. It is not a secret in any meaningful sense — every
/// installed binary carries it and it can be read straight out of one — it only
/// keeps unrelated traffic off the ingest endpoint. Rotating it on the server
/// breaks every already-installed app until a new release ships.
const String kWatchdogClientApiKey = String.fromEnvironment(
  'WATCHDOG_CLIENT_API_KEY',
  defaultValue: 'wdk_k1NIlcHVVKdW3_oAphvC8Vu30F3IUNmj',
);

/// SharedPreferences key the generated device id is stored under — the id
/// itself is created on first launch by [_generateDeviceId] and reused from
/// then on, which is what keeps one device to one dashboard session.
const String _deviceIdPrefsKey = 'watchdog_device_id';

/// True when [key] looks like a real key rather than an unedited placeholder.
///
/// `build.example.json` ships a `<...>` marker and the server's own template
/// uses `change-client-key`. Both are non-empty, so an emptiness check alone
/// lets them through — and the server then rejects every reconnect forever.
bool isValidWatchdogClientKey(String key) {
  final trimmed = key.trim();
  if (trimmed.isEmpty) return false;
  if (trimmed.startsWith('<') || trimmed.endsWith('>')) return false;
  return !trimmed.startsWith('change-');
}


/// True when [url] is something `WatchdogCloudClient` can actually dial.
///
/// Without this a bad `--dart-define` (an empty string, a pasted Dart VM
/// service URL, a plain host with no scheme) is only discovered as an endless
/// "Connection refused" retry loop against an address nobody intended.
bool isValidWatchdogServerUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;
  final uri = Uri.tryParse(trimmed);
  if (uri == null) return false;
  if (uri.scheme != 'ws' && uri.scheme != 'wss') return false;
  if (uri.host.isEmpty) return false;
  // The package appends "/ws/app" itself; a path here produces
  // ".../whatever/ws/app" and silently never connects.
  if (uri.path.isNotEmpty && uri.path != '/') return false;
  return true;
}


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
  // A bad define would otherwise show up only as an endless reconnect loop in
  // the console; better to run local-only and say why.
  final cloudReady =
      isValidWatchdogServerUrl(serverUrl) && isValidWatchdogClientKey(apiKey);
  if (!cloudReady) {
    debugPrint(
      '[Watchdog] Cloud disabled: WATCHDOG_SERVER_URL="$serverUrl" must be an '
      'origin like wss://host (no path) and WATCHDOG_CLIENT_API_KEY must be a '
      'real key. Build with --dart-define-from-file=build.json.',
    );
  }

  try {
    await Watchdog.start(``
      config: WatchdogConfig(
        enabled: true,
        // Debug: local DevTools (`watchdog open` → http://localhost:8888) plus
        // cloud. Release/profile: cloud-only so the phone does not bind a
        // localhost server on a user's LAN.
        global: !kDebugMode,
        cloud: cloudReady
            ? WatchdogCloudConfig(
                serverUrl: serverUrl,
                apiKey: apiKey,
                appName: appName,
              )
            : null,
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
  String? deviceName;
  String? model;
  String? platform;
  String? osVersion;

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

  try {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceName = info.name;
      model = info.model;
      platform = 'android';
      osVersion = info.version.release;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceName = info.name;
      model = info.utsname.machine;
      platform = 'ios';
      osVersion = info.systemVersion;
    }
  } catch (_) {
    // Device metadata is optional; the stable id and cloud stream still work.
  }

  return WatchdogDevice(
    deviceId: deviceId,
    deviceName: deviceName,
    model: model,
    platform: platform,
    osVersion: osVersion,
    appName: appName,
    appVersion: appVersion,
  );
}

String _generateDeviceId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
