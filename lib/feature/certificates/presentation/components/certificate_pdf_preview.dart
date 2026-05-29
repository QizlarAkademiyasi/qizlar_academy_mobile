import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/core/network/fetch_bytes_by_url.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// PDF ning birinchi sahifasini past aniqlikda rasterlab rasm sifatida ko‘rsatadi — interaktiv [PdfViewer] dan yengil va tezroq ochiladi.
class CertificatePdfPreview extends StatefulWidget {
  const CertificatePdfPreview({super.key, required this.fileUrl, required this.errorFallback});

  final String fileUrl;
  final Widget errorFallback;

  @override
  State<CertificatePdfPreview> createState() => _CertificatePdfPreviewState();
}

class _CertificatePdfPreviewState extends State<CertificatePdfPreview> {
  static const double _maxRasterSidePx = 440;
  static const int _pdfSignatureSearchWindowBytes = 1024;

  ui.Image? _image;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant CertificatePdfPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileUrl != widget.fileUrl) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _failed = false;
      _loading = true;
      _image?.dispose();
      _image = null;
    });

    final url = Apis.certificateFileRequestUrl(widget.fileUrl);
    if (url.isEmpty) {
      AppLogger.w('CertificatePdfPreview: empty resolved url (raw=${widget.fileUrl})');
      if (mounted) setState(_setFailed);
      return;
    }
    final parsed = Uri.tryParse(url);
    if (parsed == null || (!parsed.isScheme('https') && !parsed.isScheme('http'))) {
      AppLogger.w('CertificatePdfPreview: invalid url: $url');
      if (mounted) setState(_setFailed);
      return;
    }

    Uint8List? bytes;
    try {
      final response = await fetchBytesByUrl(
        getIt<Dio>(),
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (s) => s != null && s < 500,
          headers: const {'Accept': 'application/pdf,*/*'},
        ),
      );
      final code = response.statusCode ?? 0;
      if (code < 200 || code >= 300) {
        AppLogger.w('CertificatePdfPreview: HTTP $code for $url');
        if (mounted) setState(_setFailed);
        return;
      }
      final data = response.data;
      if (data == null || data.isEmpty) {
        AppLogger.w('CertificatePdfPreview: empty body for $url');
        if (mounted) setState(_setFailed);
        return;
      }
      bytes = Uint8List.fromList(data);
      final contentType = response.headers.value(Headers.contentTypeHeader) ?? '';
      final looksLikePdf = _looksLikePdf(bytes);
      final contentTypeSaysPdf = contentType.toLowerCase().contains('pdf');
      final urlLooksLikePdf = Uri.tryParse(url)?.path.toLowerCase().endsWith('.pdf') ?? false;
      if (!looksLikePdf && !contentTypeSaysPdf && !urlLooksLikePdf) {
        AppLogger.w(
          'CertificatePdfPreview: not a PDF (url=$url, contentType=$contentType, len=${bytes.length})',
        );
        if (mounted) setState(_setFailed);
        return;
      }
    } catch (_) {
      AppLogger.e('CertificatePdfPreview: network error while fetching $url');
      if (mounted) setState(_setFailed);
      return;
    }

    PdfDocument? doc;
    try {
      await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);
      doc = await PdfDocument.openData(bytes, sourceName: url, useProgressiveLoading: false);
      if (doc.pages.isEmpty) {
        AppLogger.w('CertificatePdfPreview: PDF has no pages (url=$url)');
        if (mounted) setState(_setFailed);
        return;
      }
      final page = await doc.pages.first.ensureLoaded();
      final pw = page.width;
      final ph = page.height;
      if (pw <= 0 || ph <= 0) {
        if (mounted) setState(_setFailed);
        return;
      }
      final longest = pw >= ph ? pw : ph;
      final scale = _maxRasterSidePx / longest;
      final pdfImg = await page.render(fullWidth: pw * scale, fullHeight: ph * scale);
      if (pdfImg == null) {
        AppLogger.w('CertificatePdfPreview: page render returned null (url=$url)');
        if (mounted) setState(_setFailed);
        return;
      }
      final flutterImg = await pdfImg.createImage();
      pdfImg.dispose();
      if (!mounted) {
        flutterImg.dispose();
        return;
      }
      setState(() {
        _image = flutterImg;
        _loading = false;
      });
    } catch (_) {
      AppLogger.e('CertificatePdfPreview: failed to render PDF (url=$url)');
      if (mounted) setState(_setFailed);
    } finally {
      await doc?.dispose();
    }
  }

  void _setFailed() {
    _failed = true;
    _loading = false;
    _image?.dispose();
    _image = null;
  }

  static bool _looksLikePdf(Uint8List bytes) {
    // Some servers may prepend whitespace/BOM before `%PDF-`, so search within a small window.
    const sig = [0x25, 0x50, 0x44, 0x46, 0x2D]; // %PDF-
    final limit = bytes.length < _pdfSignatureSearchWindowBytes ? bytes.length : _pdfSignatureSearchWindowBytes;
    if (limit < sig.length) return false;
    for (var i = 0; i <= limit - sig.length; i++) {
      var match = true;
      for (var j = 0; j < sig.length; j++) {
        if (bytes[i + j] != sig[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return widget.errorFallback;
    }
    if (_loading || _image == null) {
      return ColoredBox(
        color: context.appColors.stroke,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return ColoredBox(
      color: context.appColors.stroke,
      child: RawImage(
        image: _image,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
      ),
    );
  }
}
