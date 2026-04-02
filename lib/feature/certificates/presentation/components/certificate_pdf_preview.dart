import 'dart:typed_data';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// PDF ni [PdfViewer] (pdfrx / pdfium) orqali ko‘rsatadi — iOS implicit engine’da WebView platform view xatolari bo‘lmaydi.
class CertificatePdfPreview extends StatefulWidget {
  const CertificatePdfPreview({super.key, required this.fileUrl, required this.errorFallback});

  final String fileUrl;
  final Widget errorFallback;

  @override
  State<CertificatePdfPreview> createState() => _CertificatePdfPreviewState();
}

class _CertificatePdfPreviewState extends State<CertificatePdfPreview> {
  Uint8List? _bytes;
  String? _sourceName;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final url = Apis.resolveUrl(widget.fileUrl);
    if (url.isEmpty) {
      if (mounted) setState(() => _setFailed());
      return;
    }
    final parsed = Uri.tryParse(url);
    if (parsed == null || (!parsed.isScheme('https') && !parsed.isScheme('http'))) {
      if (mounted) setState(() => _setFailed());
      return;
    }

    try {
      final response = await getIt<Dio>().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (s) => s != null && s < 500,
        ),
      );
      final code = response.statusCode ?? 0;
      if (code < 200 || code >= 300) {
        if (mounted) setState(() => _setFailed());
        return;
      }
      final data = response.data;
      if (data == null || data.isEmpty) {
        if (mounted) setState(() => _setFailed());
        return;
      }
      final bytes = Uint8List.fromList(data);
      if (!_looksLikePdf(bytes)) {
        if (mounted) setState(() => _setFailed());
        return;
      }
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        _sourceName = url;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _setFailed());
    }
  }

  void _setFailed() {
    _failed = true;
    _loading = false;
  }

  static bool _looksLikePdf(Uint8List bytes) {
    return bytes.length >= 5 && bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46 && bytes[4] == 0x2D;
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return widget.errorFallback;
    }
    if (_loading || _bytes == null || _sourceName == null) {
      return ColoredBox(
        color: context.appColors.stroke,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return ColoredBox(
      color: context.appColors.stroke,
      child: PdfViewer.data(
        _bytes!,
        sourceName: _sourceName!,
        useProgressiveLoading: true,
        params: PdfViewerParams(
          backgroundColor: context.appColors.stroke,
          margin: 4,
          calculateInitialZoom: (_, _, fitZoom, _) => fitZoom,
        ),
      ),
    );
  }
}
