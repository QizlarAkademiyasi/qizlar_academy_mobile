import 'dart:async';

import 'package:qizlar_academy_mobile/config/bootstrap/app_bootstrap.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';

void main() {
  if (!EnvConfig.isInitialized) {
    final flavor = EnvConfig.resolveFlavor();
    final appName = flavor == AppFlavors.dev
        ? 'Qizlar Akademiyasi (Dev)'
        : 'Qizlar Akademiyasi';
    EnvConfig.initialize(appName: appName, flavor: flavor);
  }

  runZonedGuarded<Future<void>>(() async {
    await AppBootstrap.start();
  }, AppBootstrap.onUncaughtZoneError);
}

// For app assets generation:
// cd packages/qizlar_academy_kit && dart run build_runner build --delete-conflicting-outputs
