import 'dart:io';
import 'dart:typed_data';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/core/network/fetch_bytes_by_url.dart';

/// Sertifikat faylini yuklab vaqtincha saqlab, tizim ulashish oynasini ochadi.
class CertificateFileActions {
  CertificateFileActions(this._dio);

  final Dio _dio;

  Future<void> downloadAndShare(String rawUrl, {required String fileBaseName}) async {
    final url = Apis.certificateFileRequestUrl(rawUrl);
    if (url.isEmpty) {
      throw StateError('empty_url');
    }
    final response = await fetchBytesByUrl(
      _dio,
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

  /// `/api/v1/certificate/image/{courseId}` dan PNG — vaqtinchalik fayl yo‘li.
  Future<String> saveCertificatePngToTempPath(String courseId, {required String fileBaseName}) async {
    final bytes = await _fetchCertificatePngBytes(courseId);
    final safeName = _sanitizeFileName(fileBaseName);
    final path = '${Directory.systemTemp.path}/cert_${safeName}_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  /// `/api/v1/certificate/image/{courseId}` dan PNG buffer yuklab, vaqtinchalik faylga yozib ulashadi.
  ///
  /// [ResponseType.bytes] bilan olinadi. Status 500 bo‘lsa ham, tana haqiqiy PNG bo‘lsa, ulashiladi.
  Future<void> downloadCertificatePngAndShare(String courseId, {required String fileBaseName}) async {
    final id = courseId.trim();
    if (id.isEmpty) {
      throw StateError('empty_course_id');
    }
    final bytes = await _fetchCertificatePngBytes(id);
    final safeName = _sanitizeFileName(fileBaseName);
    final path = '${Directory.systemTemp.path}/$safeName.png';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'image/png')]));
  }

  Future<Uint8List> _fetchCertificatePngBytes(String courseId) async {
    final id = courseId.trim();
    if (id.isEmpty) {
      throw StateError('empty_course_id');
    }
    final response = await _dio.get<List<int>>(
      UserApis.certificateImageByCourseId(id),
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        validateStatus: (_) => true,
        headers: const {'Accept': 'image/png,application/png,*/*'},
      ),
    );
    final code = response.statusCode ?? 0;
    final raw = response.data;
    if (raw == null || raw.isEmpty) {
      if (code < 200 || code >= 300) {
        AppLogger.w('CertificateFileActions: certificate image HTTP $code, empty body (courseId=$id)');
        throw StateError('http_$code');
      }
      throw StateError('empty_body');
    }
    final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
    if (_looksLikePng(bytes)) {
      if (code < 200 || code >= 300) {
        AppLogger.w('CertificateFileActions: HTTP $code but body is PNG — ok (courseId=$id)');
      }
    } else {
      if (code < 200 || code >= 300) {
        AppLogger.w('CertificateFileActions: certificate image HTTP $code, not PNG body (courseId=$id, len=${bytes.length})');
        throw StateError('http_$code');
      }
      AppLogger.w('CertificateFileActions: body is not PNG (courseId: $id, len=${bytes.length})');
      throw StateError('not_png');
    }
    return bytes;
  }

  static bool _looksLikePng(Uint8List bytes) {
    return bytes.length >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47 && bytes[4] == 0x0D && bytes[5] == 0x0A && bytes[6] == 0x1A && bytes[7] == 0x0A;
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
