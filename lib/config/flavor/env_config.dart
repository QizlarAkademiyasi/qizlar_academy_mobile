import 'package:flutter/foundation.dart';

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

  static void initialize({
    required String appName,
    required AppFlavors flavor,
  }) {
    _instance = EnvConfig._(appName: appName, flavor: flavor);
    debugPrint(
      '[EnvConfig] Flavor: ${_instance!.flavor.name.toUpperCase()} | '
      'App: ${_instance!.appName}',
    );
  }

  static bool get isInitialized => _instance != null;

  static EnvConfig get instance {
    assert(
      _instance != null,
      'EnvConfig.initialize() chaqirilmagan. '
      'main_dev.dart yoki main_prod.dart orqali ilovani ishga tushiring.',
    );
    return _instance!;
  }

  bool get isDev => flavor == AppFlavors.dev;
  bool get isProd => flavor == AppFlavors.prod;
}
