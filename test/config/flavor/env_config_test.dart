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
}
