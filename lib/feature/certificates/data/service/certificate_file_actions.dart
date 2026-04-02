import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';

/// Sertifikat faylini yuklab vaqtincha saqlab, tizim ulashish oynasini ochadi.
class CertificateFileActions {
  CertificateFileActions(this._dio);

  final Dio _dio;

  Future<void> downloadAndShare(String rawUrl, {required String fileBaseName}) async {
    final url = Apis.resolveUrl(rawUrl);
    if (url.isEmpty) {
      throw StateError('empty_url');
    }
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes, followRedirects: true, validateStatus: (s) => s != null && s < 500),
    );
    final code = response.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      AppLogger.w('CertificateFileActions: HTTP $code for $url');
      throw StateError('http_$code');
    }
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('empty_body');
    }
    final ext = _extensionFromUrl(url);
    final safeName = _sanitizeFileName(fileBaseName);
    final path = '${Directory.systemTemp.path}/$safeName$ext';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  static String _sanitizeFileName(String name) {
    var s = name.trim().replaceAll(RegExp(r'[/\\:*?"<>|]'), '_');
    if (s.isEmpty) return 'certificate';
    return s.length > 80 ? s.substring(0, 80) : s;
  }

  static String _extensionFromUrl(String url) {
    try {
      final path = Uri.parse(url).path.toLowerCase();
      if (path.endsWith('.pdf')) return '.pdf';
      if (path.endsWith('.png')) return '.png';
      if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return '.jpg';
    } catch (_) {}
    return '.bin';
  }
}
