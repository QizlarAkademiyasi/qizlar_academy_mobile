import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/meta_share_constants.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';

/// `/api/v1/certificate/image/{courseId}` dan PNG olib Instagram Story (sticker) sifatida ochadi.
class CertificateInstagramStoryShare {
  CertificateInstagramStoryShare(this._fileActions);

  final CertificateFileActions _fileActions;

  Future<void> shareCertificateSticker(String courseId, {required String fileBaseName}) async {
    final appId = MetaShareConstants.facebookAppId.trim();
    if (appId.isEmpty) {
      throw StateError('facebook_app_id_missing');
    }
    final id = courseId.trim();
    if (id.isEmpty) {
      throw StateError('empty_course_id');
    }
    final path = await _fileActions.saveCertificatePngToTempPath(id, fileBaseName: fileBaseName);
    final share = createAppinioSocialShare();
    final String result;
    if (Platform.isAndroid) {
      result = await share.android.shareToInstagramStory(appId, stickerImage: path);
    } else if (Platform.isIOS) {
      result = await share.iOS.shareToInstagramStory(appId, stickerImage: path);
    } else {
      throw UnsupportedError('instagram_story_unsupported_platform');
    }
    if (result != 'SUCCESS') {
      AppLogger.w('CertificateInstagramStoryShare: native result=$result');
      throw StateError(result);
    }
  }
}
