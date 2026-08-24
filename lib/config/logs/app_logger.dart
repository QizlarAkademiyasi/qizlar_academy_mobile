import 'dart:convert';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_log_config.dart';
import 'package:qizlar_academy_mobile/core/watchdog/watchdog_integrations.dart';

/// Ilova bo'ylab yagona logging nuqtasi.
/// Logger dan to'g'ridan-to'g'ri emas, shu class orqali foydalaniladi.
///
/// Chiqish [AppLogConfig.loggingEnabled] bilan boshqariladi (dev flavor da yoqiladi).
final class AppLogger {
  AppLogger._();
  static final JsonEncoder _jsonEncoder = const JsonEncoder.withIndent('  ');

  static final Logger _logger = Logger(
    level: Level.trace,
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 120, colors: false, printEmojis: true, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
  );

  static void t(dynamic message, {Object? error, StackTrace? stackTrace}) {
    // Watchdog mirroring sits *before* the gate: console output is dev-only,
    // but the dashboard is meant to work in every build.
    watchdogDebug(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.t(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static void d(dynamic message, {Object? error, StackTrace? stackTrace}) {
    watchdogDebug(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.d(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static void i(dynamic message, {Object? error, StackTrace? stackTrace}) {
    watchdogInfo(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.i(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static void w(dynamic message, {Object? error, StackTrace? stackTrace}) {
    watchdogWarning(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.w(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    watchdogError(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.e(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static void f(dynamic message, {Object? error, StackTrace? stackTrace}) {
    watchdogError(_asText(message), error: error, stackTrace: stackTrace);
    if (!AppLogConfig.loggingEnabled) return;
    _logger.f(_normalizeValue(message), error: _normalizeValue(error), stackTrace: stackTrace);
  }

  static String _asText(dynamic message) {
    final normalized = _normalizeValue(message);
    return normalized?.toString() ?? 'null';
  }

  static Object? _normalizeValue(Object? value) {
    if (value == null) return null;
    if (value is Map || value is List) {
      try {
        return _jsonEncoder.convert(value);
      } catch (_) {
        return value.toString();
      }
    }
    return value;
  }
}
