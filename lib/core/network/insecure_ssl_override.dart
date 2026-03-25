import 'dart:io';

import 'package:dio/io.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Temporarily bypasses certificate validation outside release mode.
void applyInsecureSslOverride(Dio dio) {
  if (const bool.fromEnvironment('dart.vm.product')) return;

  final adapter = dio.httpClientAdapter;
  if (adapter is IOHttpClientAdapter) {
    adapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (_, __, ___) => true;
      return client;
    };
  }
}
