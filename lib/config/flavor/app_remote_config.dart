import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/remote_config_feature_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/remote_config_force_update_keys.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

final class AppRemoteConfig {
  final String domain;

  /// Remote Config `google_sign_in` — `true` bo‘lsa Google Sign-In UI yoqilgan.
  final bool googleSignInEnabled;

  AppRemoteConfig._(this.domain, this.googleSignInEnabled);

  static AppRemoteConfig? _instance;

  static AppRemoteConfig get instance {
    assert(
      _instance != null,
      'AppRemoteConfig.initialize() chaqirilmagan. '
      'setupLocator() ichida chaqirilganini tekshiring.',
    );
    return _instance!;
  }

  /// Remote Config: qisqaroq tarmoq timeout, xatolikda [activate].
  static Future<void> initialize() async {
    final totalSw = Stopwatch()..start();
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 12),
        minimumFetchInterval: EnvConfig.instance.isDev
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    final defaults = <String, Object>{
      RemoteConfigForceUpdateKeys.applicationStoreLink:
          'https://onelink.to/4h9hr9',
      RemoteConfigForceUpdateKeys.currentAppVersion: '1.7.0',
      RemoteConfigForceUpdateKeys.minimumSupportedAppVersion: '1.7.0',
      RemoteConfigFeatureKeys.googleSignIn: false,
    };
    await remoteConfig.setDefaults(defaults);

    final fetchSw = Stopwatch()..start();
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e, st) {
      AppLogger.w(
        'Remote Config fetchAndActivate failed; trying activate()',
        error: e,
        stackTrace: st,
      );
      try {
        await remoteConfig.activate();
      } catch (e2, st2) {
        AppLogger.w(
          'Remote Config activate failed',
          error: e2,
          stackTrace: st2,
        );
      }
    }
    final fetchMs = fetchSw.elapsedMilliseconds;

    final remoteConfigKey = EnvConfig.instance.remoteConfigKey;
    final remoteDomain = RemoteConfigDomainResolver.extract(
      remoteConfig.getString(remoteConfigKey),
    );

    final googleSignInEnabled = remoteConfig.getBool(
      RemoteConfigFeatureKeys.googleSignIn,
    );

    _instance = AppRemoteConfig._(remoteDomain, googleSignInEnabled);

    final forceUpdateStoreLink = remoteConfig
        .getString(RemoteConfigForceUpdateKeys.applicationStoreLink)
        .trim();
    final forceUpdateCurrent = remoteConfig
        .getString(RemoteConfigForceUpdateKeys.currentAppVersion)
        .trim();
    final forceUpdateMinimum = remoteConfig
        .getString(RemoteConfigForceUpdateKeys.minimumSupportedAppVersion)
        .trim();

    AppLogger.i(<String, dynamic>{
      'remoteConfig': 'domain + force_update (startup)',
      'flavor': EnvConfig.instance.flavor.name,
      'fetchAndActivate_ms': fetchMs,
      'initialize_total_ms': totalSw.elapsedMilliseconds,
      'remoteConfigKey': remoteConfigKey,
      'resolvedDomain': remoteDomain,
      RemoteConfigForceUpdateKeys.applicationStoreLink: forceUpdateStoreLink,
      RemoteConfigForceUpdateKeys.currentAppVersion: forceUpdateCurrent,
      RemoteConfigForceUpdateKeys.minimumSupportedAppVersion:
          forceUpdateMinimum,
      RemoteConfigFeatureKeys.googleSignIn: googleSignInEnabled,
    });
  }
}

/// Remote Config qiymatlaridan xavfsiz API domenini tanlaydi.
final class RemoteConfigDomainResolver {
  const RemoteConfigDomainResolver._();

  static String extract(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      final uri = Uri.tryParse(value);
      return _isUsableHttpUri(uri) ? uri.toString() : '';
    }

    final normalized = value.replaceAll("'", '"');
    try {
      final decoded = jsonDecode(normalized);
      if (decoded is Map<String, dynamic>) {
        return extract((decoded['domain'] ?? '').toString());
      }
      if (decoded is Map) {
        return extract((decoded['domain'] ?? '').toString());
      }
    } catch (_) {
      // Remote Config qiymati JSON bo'lmasa, quyida regex bilan tekshiriladi.
    }

    final match = RegExp(
      r'https?:\/\/[A-Za-z0-9\.\-:_~\/\?#\[\]@!\$&\(\)\*\+,;=%]+',
    ).firstMatch(value);
    return extract(match?.group(0)?.trim() ?? '');
  }

  static bool _isUsableHttpUri(Uri? uri) {
    if (uri == null || !uri.hasAuthority || uri.host.trim().isEmpty) {
      return false;
    }
    return uri.isScheme('https') || uri.isScheme('http');
  }
}
