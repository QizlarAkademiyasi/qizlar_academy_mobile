import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/app_log_config.dart';

void main() {
  group('EnvConfig logging', () {
    test('enables logs for the dev flavor', () {
      EnvConfig.initialize(
        appName: 'Qizlar Akademiyasi (Dev)',
        flavor: AppFlavors.dev,
      );

      expect(AppLogConfig.loggingEnabled, isTrue);
    });

    test('disables logs for the prod flavor', () {
      EnvConfig.initialize(
        appName: 'Qizlar Akademiyasi',
        flavor: AppFlavors.prod,
      );

      expect(AppLogConfig.loggingEnabled, isFalse);
    });
  });

  group('EnvConfig.flavorFrom', () {
    test('uses the native --flavor value', () {
      expect(
        EnvConfig.flavorFrom(appFlavorValue: 'dev', releaseMode: true),
        AppFlavors.dev,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: 'DEV', releaseMode: true),
        AppFlavors.dev,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: 'prod', releaseMode: false),
        AppFlavors.prod,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: ' PROD ', releaseMode: false),
        AppFlavors.prod,
      );
    });

    test('falls back to debug=dev and release=prod when flavor is missing', () {
      expect(
        EnvConfig.flavorFrom(appFlavorValue: null, releaseMode: false),
        AppFlavors.dev,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: '', releaseMode: false),
        AppFlavors.dev,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: null, releaseMode: true),
        AppFlavors.prod,
      );
      expect(
        EnvConfig.flavorFrom(appFlavorValue: 'unknown', releaseMode: true),
        AppFlavors.prod,
      );
    });

    test('resolveFlavor follows Flutter appFlavor', () {
      expect(
        EnvConfig.resolveFlavor(),
        EnvConfig.flavorFrom(
          appFlavorValue: appFlavor,
          releaseMode: false,
        ),
      );
    });
  });
}
