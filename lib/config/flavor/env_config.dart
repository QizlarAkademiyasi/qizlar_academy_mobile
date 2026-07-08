import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:qizlar_academy_mobile/config/logs/app_log_config.dart';

enum AppFlavors {
  dev(remoteConfigKey: 'devUrl'),
  prod(remoteConfigKey: 'baseUrl');

  const AppFlavors({required this.remoteConfigKey});

  final String remoteConfigKey;
}

final class EnvConfig {
  final String appName;
  final AppFlavors flavor;

  String get remoteConfigKey => flavor.remoteConfigKey;

  EnvConfig._({required this.appName, required this.flavor});

  static EnvConfig? _instance;

  /// Android `--flavor` → [appFlavor]; iOS/flavor yo‘q build → release=prod, debug=dev.
  static AppFlavors resolveFlavor() {
    const fromDefine = String.fromEnvironment('FLAVOR', defaultValue: '');
    switch (fromDefine.trim().toLowerCase()) {
      case 'prod':
        return AppFlavors.prod;
      case 'dev':
        return AppFlavors.dev;
    }

    switch (appFlavor?.trim().toLowerCase()) {
      case 'prod':
        return AppFlavors.prod;
      case 'dev':
        return AppFlavors.dev;
    }

    return kReleaseMode ? AppFlavors.prod : AppFlavors.dev;
  }

  static void initialize({
    required String appName,
    required AppFlavors flavor,
  }) {
    _instance = EnvConfig._(appName: appName, flavor: flavor);
    AppLogConfig.loggingEnabled = flavor == AppFlavors.prod;
    if (AppLogConfig.loggingEnabled) {
      debugPrint(
        '[EnvConfig] Flavor: ${_instance!.flavor.name.toUpperCase()} | '
        'App: ${_instance!.appName} | appFlavor: ${appFlavor ?? 'null'}',
      );
    }
  }

  static bool get isInitialized => _instance != null;

  static EnvConfig get instance {
    assert(
      _instance != null,
      'EnvConfig.initialize() chaqirilmagan. '
      'main.dart da EnvConfig.initialize() chaqirilishini tekshiring.',
    );
    return _instance!;
  }

  bool get isDev => flavor == AppFlavors.dev;
  bool get isProd => flavor == AppFlavors.prod;
}
