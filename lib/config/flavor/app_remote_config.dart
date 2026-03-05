import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';

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

    final json = remoteConfig.getString(EnvConfig.instance.remoteConfigKey);

    if (json.isEmpty) {
      _instance = AppRemoteConfig._('');
      return;
    }

    final String domain = jsonDecode(json)['domain'] as String? ?? '';
    _instance = AppRemoteConfig._(domain);
  }
}
