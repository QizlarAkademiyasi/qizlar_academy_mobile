import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/facebook_config.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';

/// Sertifikat PNG ni Instagram Story sticker sifatida ulashish ([AppinioSocialShare]).
///
/// App ID manbai — [FacebookConfig.appId] (build-time `FACEBOOK_APP_ID` yoki
/// loyihaning production fallback ID si). Konfiguratsiya yo‘q bo‘lsa
/// [StateError] `facebook_app_id_missing` ko‘tariladi.
class CertificateInstagramStoryShare {
  CertificateInstagramStoryShare(this._fileActions);

  final CertificateFileActions _fileActions;

  Future<void> shareCertificateSticker(String courseId, {required String fileBaseName}) async {
    if (!FacebookConfig.isConfigured) {
      throw StateError('facebook_app_id_missing');
    }
    final appId = FacebookConfig.appId;
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
