import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

class AppNetworkLoggerInterceptor extends Interceptor {
  AppNetworkLoggerInterceptor({this.maxBodyLength = 4000});

  static const String _startedAtKey = '_requestStartedAt';
  final int maxBodyLength;
  final JsonEncoder _prettyEncoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now().millisecondsSinceEpoch;
    final payload = <String, dynamic>{
      'url': options.uri.toString(),
      'contentType': options.contentType,
      'headers': _sanitizeHeaders(options.headers),
      if (options.queryParameters.isNotEmpty) 'query': options.queryParameters,
      if (options.data != null) 'body': _safeBody(options.data),
    };
    AppLogger.d(_buildLogBlock('HTTP REQUEST', options.method, payload));
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final elapsedMs = _elapsedMs(response.requestOptions);
    final payload = <String, dynamic>{
      'url': response.requestOptions.uri.toString(),
      'statusCode': response.statusCode,
      'statusMessage': response.statusMessage,
      if (elapsedMs != null) 'durationMs': elapsedMs,
      'response': _safeBody(response.data),
    };
    final log = _buildLogBlock(
      'HTTP RESPONSE',
      response.requestOptions.method,
      payload,
    );
    if ((response.statusCode ?? 0) >= 400) {
      AppLogger.w(log);
    } else {
      AppLogger.i(log);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final elapsedMs = _elapsedMs(err.requestOptions);
    final payload = <String, dynamic>{
      'url': err.requestOptions.uri.toString(),
      'statusCode': err.response?.statusCode,
      'type': err.type.name,
      'message': _resolveDioMessage(err),
      if (err.error != null) 'error': err.error.toString(),
      if (elapsedMs != null) 'durationMs': elapsedMs,
      'contentType': err.requestOptions.contentType,
      'headers': _sanitizeHeaders(err.requestOptions.headers),
      if (err.requestOptions.queryParameters.isNotEmpty)
        'query': err.requestOptions.queryParameters,
      if (err.requestOptions.data != null) 'body': _safeBody(err.requestOptions.data),
      'response': _safeBody(err.response?.data),
    };
    AppLogger.e(
      _buildLogBlock('HTTP ERROR', err.requestOptions.method, payload),
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final normalizedKey = key.toLowerCase();
      if (normalizedKey == 'authorization' || normalizedKey == 'cookie') {
        final token = value?.toString() ?? '';
        final masked = token.length <= 16
            ? '***'
            : '${token.substring(0, 12)}...${token.substring(token.length - 4)}';
        return MapEntry(key, masked);
      }
      return MapEntry(key, value);
    });
  }

  dynamic _safeBody(dynamic data) {
    if (data == null) return null;

    if (data is FormData) {
      return <String, dynamic>{
        'fields': Map<String, String>.fromEntries(
          data.fields.map((field) => MapEntry(field.key, field.value)),
        ),
        'files': data.files
            .map(
              (file) => <String, dynamic>{
                'key': file.key,
                'filename': file.value.filename,
                'contentType': file.value.contentType?.toString(),
              },
            )
            .toList(growable: false),
      };
    }

    if (data is Map || data is List) {
      return _truncateStructured(data);
    }

    if (data is String) {
      final pretty = _prettyString(data);
      final trimmed = pretty.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          return _truncateStructured(jsonDecode(trimmed));
        } catch (_) {
          return _truncate(pretty);
        }
      }
      return _truncate(pretty);
    }

    return _truncate(data.toString());
  }

  String _prettyEncode(dynamic data) {
    try {
      return _prettyEncoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _prettyString(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return value;
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        return _prettyEncoder.convert(jsonDecode(trimmed));
      } catch (_) {
        return value;
      }
    }
    return value;
  }

  String _truncate(String value) {
    if (value.length <= maxBodyLength) return value;
    return '${value.substring(0, maxBodyLength)} ...<truncated>';
  }

  dynamic _truncateStructured(dynamic data) {
    try {
      final encoded = _prettyEncode(data);
      if (encoded.length <= maxBodyLength) return data;
      return _truncate(encoded);
    } catch (_) {
      return _truncate(data.toString());
    }
  }

  int? _elapsedMs(RequestOptions options) {
    final startedAt = options.extra[_startedAtKey];
    if (startedAt is! int) return null;
    return DateTime.now().millisecondsSinceEpoch - startedAt;
  }

  String _buildLogBlock(String title, String method, Map<String, dynamic> payload) {
    return '$title [$method]\n${_prettyEncode(payload)}';
  }

  String _resolveDioMessage(DioException err) {
    final directMessage = err.message;
    if (directMessage != null && directMessage.trim().isNotEmpty) {
      return directMessage;
    }

    final rawError = err.error;
    if (rawError is Exception || rawError is Error) {
      final text = rawError.toString();
      if (text.trim().isNotEmpty) return text;
    }

    return 'No exception message';
  }
}
