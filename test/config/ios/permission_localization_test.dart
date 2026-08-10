import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iOS permission localization', () {
    const supportedLocales = ['en', 'ru', 'uz'];
    const requiredKeys = [
      'NSUserTrackingUsageDescription',
      'NSPhotoLibraryUsageDescription',
      'NSPhotoLibraryAddUsageDescription',
      'NSMicrophoneUsageDescription',
    ];

    test('embeds localized permission descriptions for every app locale', () {
      final project = File(
        'ios/Runner.xcodeproj/project.pbxproj',
      ).readAsStringSync();

      for (final locale in supportedLocales) {
        final stringsFile = File('ios/Runner/$locale.lproj/InfoPlist.strings');
        expect(stringsFile.existsSync(), isTrue, reason: '$locale is missing');

        final contents = stringsFile.readAsStringSync();
        for (final key in requiredKeys) {
          expect(contents, contains('"$key"'));
        }
        expect(project, contains('name = $locale;'));
      }

      expect(project, contains('InfoPlist.strings in Resources'));
    });

    test('does not declare unused sensitive permissions', () {
      final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();
      final podfile = File('ios/Podfile').readAsStringSync();

      for (final unusedKey in const [
        'NSCameraUsageDescription',
        'NSContactsUsageDescription',
        'NSLocationWhenInUseUsageDescription',
        'NSCalendarsUsageDescription',
        'NSSpeechRecognitionUsageDescription',
        'NSMotionUsageDescription',
        'NSRemindersUsageDescription',
        'NSBluetoothAlwaysUsageDescription',
        'NSSiriUsageDescription',
        'NSAppleMusicUsageDescription',
      ]) {
        expect(infoPlist, isNot(contains(unusedKey)));
      }

      expect(podfile, isNot(contains('PERMISSION_CAMERA=1')));
      expect(podfile, isNot(contains('PERMISSION_MICROPHONE=1')));
      expect(podfile, contains('PERMISSION_PHOTOS=1'));
    });
  });
}
