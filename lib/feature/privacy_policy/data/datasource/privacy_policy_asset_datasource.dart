import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';

class PrivacyPolicyAssetDatasource {
  const PrivacyPolicyAssetDatasource();

  static const String assetPath = 'packages/qizlar_academy_kit/assets/markdown/privacy-policy.md';

  Future<String> loadMarkdown() async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e, st) {
      AppLogger.w('PrivacyPolicyAssetDatasource: load failed ($assetPath)', error: e, stackTrace: st);
      rethrow;
    }
  }
}
