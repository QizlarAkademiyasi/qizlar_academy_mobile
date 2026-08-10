import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';

void main() {
  group('RemoteConfigDomainResolver', () {
    test('uses the Firebase Console production and development keys', () {
      expect(AppFlavors.prod.remoteConfigKey, 'baseUrl');
      expect(AppFlavors.dev.remoteConfigKey, 'devUrl');
    });

    test('extracts the exact Firebase Console domain values', () {
      expect(
        RemoteConfigDomainResolver.extract(
          '{"domain":"https://back.qizlarakademiyasi.uz"}',
        ),
        'https://back.qizlarakademiyasi.uz',
      );
      expect(
        RemoteConfigDomainResolver.extract(
          '{"domain":"https://api.qizlarakademiyasi.uz"}',
        ),
        'https://api.qizlarakademiyasi.uz',
      );
    });

    test('extracts plain and JSON-wrapped domains', () {
      expect(
        RemoteConfigDomainResolver.extract('https://api.qizlarakademiyasi.uz'),
        'https://api.qizlarakademiyasi.uz',
      );
      expect(
        RemoteConfigDomainResolver.extract(
          '{"domain":"https://api.qizlarakademiyasi.uz"}',
        ),
        'https://api.qizlarakademiyasi.uz',
      );
      expect(
        RemoteConfigDomainResolver.extract(
          "{'domain':'https://api.qizlarakademiyasi.uz'}",
        ),
        'https://api.qizlarakademiyasi.uz',
      );
    });

    test('rejects empty and non-http values', () {
      expect(RemoteConfigDomainResolver.extract(''), isEmpty);
      expect(RemoteConfigDomainResolver.extract('api.example.com'), isEmpty);
      expect(
        RemoteConfigDomainResolver.extract('ftp://api.example.com'),
        isEmpty,
      );
    });
  });
}
