import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

final class AppRemoteConfig {
  final String domain;

  AppRemoteConfig._(this.domain);

  static AppRemoteConfig? _instance;

  static AppRemoteConfig get instance {
    assert(
      _instance != null,
      'AppRemoteConfig.initialize() chaqirilmagan. '
      'setupLocator() ichida chaqirilganini tekshiring.',
    );
    return _instance!;
  }

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: EnvConfig.instance.isDev
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    await remoteConfig.fetchAndActivate();

    // Remote Config dan faqat shu 2 key o'qiladi.
    final baseUrlRaw = remoteConfig.getString(AppFlavors.prod.remoteConfigKey);
    final devUrlRaw = remoteConfig.getString(AppFlavors.dev.remoteConfigKey);

    final baseDomain = _extractDomain(baseUrlRaw);
    final devDomain = _extractDomain(devUrlRaw);
    final resolvedDomain = EnvConfig.instance.isDev ? devDomain : baseDomain;

    _instance = AppRemoteConfig._(resolvedDomain);

    AppLogger.i(
      'Remote config domain resolved',
      error: <String, dynamic>{
        'flavor': EnvConfig.instance.flavor.name,
        'baseDomain': baseDomain,
        'devDomain': devDomain,
        'resolvedDomain': resolvedDomain,
      },
    );
  }

  static String _extractDomain(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final normalized = value.replaceAll("'", '"');
    try {
      final decoded = jsonDecode(normalized);
      if (decoded is Map<String, dynamic>) {
        return (decoded['domain'] ?? '').toString().trim();
      }
      if (decoded is Map) {
        return (decoded['domain'] ?? '').toString().trim();
      }
    } catch (_) {
      // Remote Config qiymati JSON bo'lmasa, quyida regex bilan tekshiriladi.
    }

    final match = RegExp(
      r'https?:\/\/[A-Za-z0-9\.\-:_~\/\?#\[\]@!\$&\(\)\*\+,;=%]+',
    ).firstMatch(value);
    return match?.group(0)?.trim() ?? '';
  }
}
