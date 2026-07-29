import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('native deep-link configuration', () {
    test(
      'Runner target embeds associated-domain entitlements in every build',
      () {
        final project = File(
          'ios/Runner.xcodeproj/project.pbxproj',
        ).readAsStringSync();
        final entitlementSetting = RegExp(
          r'CODE_SIGN_ENTITLEMENTS = Runner/Runner\.entitlements;',
        );

        expect(entitlementSetting.allMatches(project), hasLength(3));

        final entitlements = File(
          'ios/Runner/Runner.entitlements',
        ).readAsStringSync();
        expect(entitlements, contains('applinks:qizlarakademiyasi.uz'));
        expect(entitlements, contains('applinks:www.qizlarakademiyasi.uz'));
      },
    );

    test('iOS association file allows portfolio links', () {
      final association =
          jsonDecode(
                File('ios/apple-app-site-association.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final appLinks = association['applinks'] as Map<String, dynamic>;
      final details = appLinks['details'] as List<dynamic>;
      final firstDetail = details.first as Map<String, dynamic>;
      final paths = (firstDetail['paths'] as List<dynamic>).cast<String>();

      expect(firstDetail['appID'], 'C8ASSFN5K9.uz.qizlar.akademiyasi');
      expect(paths, contains('/portfolio/*'));
    });

    test('Android verifies both canonical hosts', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      final gradle = File('android/app/build.gradle.kts').readAsStringSync();

      expect(manifest, contains('android:host="\${deepLinkHost}"'));
      expect(manifest, contains('android:host="www.qizlarakademiyasi.uz"'));
      expect(gradle, contains('?: "qizlarakademiyasi.uz"'));
    });
  });
}
