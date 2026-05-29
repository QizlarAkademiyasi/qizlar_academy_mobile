import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/network/app_network_logger_interceptor.dart';
import 'package:qizlar_academy_mobile/core/network/insecure_ssl_override.dart';

/// CDN/R2 kabi tashqi URL’larda API Bearer token yuborilmasin — ba’zi hostlar buni rad qiladi.
///
/// [url] hosti [Apis.baseUrl] hosti bilan bir xil bo‘lsa [authenticatedDio] ishlatiladi.
Future<Response<List<int>>> fetchBytesByUrl(
  Dio authenticatedDio,
  String url, {
  required Options options,
}) async {
  final api = Uri.tryParse(Apis.baseUrl.trim());
  final target = Uri.tryParse(url);
  final apiHost = (api?.host ?? '').toLowerCase();
  final targetHost = (target?.host ?? '').toLowerCase();
  final sameApiHost =
      apiHost.isNotEmpty && targetHost.isNotEmpty && apiHost == targetHost;

  if (sameApiHost) {
    return authenticatedDio.get<List<int>>(url, options: options);
  }

  final plain = Dio(
    BaseOptions(
      connectTimeout: authenticatedDio.options.connectTimeout ?? const Duration(seconds: 20),
      receiveTimeout: authenticatedDio.options.receiveTimeout ?? const Duration(seconds: 20),
    ),
  );
  applyInsecureSslOverride(plain);
  plain.interceptors.add(AppNetworkLoggerInterceptor());
  return plain.get<List<int>>(url, options: options);
}
