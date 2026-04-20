import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';

/// Sertifikat PNG ni Instagram Story sticker sifatida ulashish ([AppinioSocialShare]).
///
/// Facebook App ID `--dart-define=FACEBOOK_APP_ID=...` yoki bo‘sh — [StateError] `facebook_app_id_missing`.
class CertificateInstagramStoryShare {
  CertificateInstagramStoryShare(this._fileActions);

  final CertificateFileActions _fileActions;

  Future<void> shareCertificateSticker(String courseId, {required String fileBaseName}) async {
    final appId = const String.fromEnvironment('FACEBOOK_APP_ID', defaultValue: '1262098222769251').trim();
    if (appId.isEmpty) {
      throw StateError('facebook_app_id_missing');
    }
    final stickerPath = await _fileActions.saveCertificatePngToTempPath(courseId, fileBaseName: fileBaseName);
    final share = AppinioSocialShare();
    if (Platform.isAndroid) {
      await share.android.shareToInstagramStory(appId, stickerImage: stickerPath);
    } else if (Platform.isIOS) {
      await share.iOS.shareToInstagramStory(appId, stickerImage: stickerPath);
    } else {
      throw UnsupportedError('instagram_story_unsupported_platform');
    }
  }
}
