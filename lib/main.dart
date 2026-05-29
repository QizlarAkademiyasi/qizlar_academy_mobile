import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:qizlar_academy_mobile/config/bootstrap/app_bootstrap.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';

void main() {
  if (!EnvConfig.isInitialized) {
    EnvConfig.initialize(appName: 'Qizlar Akademiyasi', flavor: kReleaseMode ? AppFlavors.prod : AppFlavors.dev);
  }

  runZonedGuarded<Future<void>>(() async {
    await AppBootstrap.start();
  }, AppBootstrap.onUncaughtZoneError);
}

// For app assets generation:
// cd packages/qizlar_academy_kit && dart run build_runner build --delete-conflicting-outputs
