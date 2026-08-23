import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:watchdog/watchdog.dart';

void attachWatchdogToDio(Dio dio) {
  if (!dio.interceptors.contains(Watchdog.dioInterceptor)) {
    dio.interceptors.add(Watchdog.dioInterceptor);
  }
}

void trackWatchdogGetIt(GetIt getIt) {
  Watchdog.trackGetIt(getIt);
}

void watchdogDebug(String message, {Object? error, StackTrace? stackTrace}) {
  Watchdog.debug(message, error: error, stackTrace: stackTrace);
}

void watchdogInfo(String message, {Object? error, StackTrace? stackTrace}) {
  Watchdog.info(message, error: error, stackTrace: stackTrace);
}

void watchdogWarning(String message, {Object? error, StackTrace? stackTrace}) {
  Watchdog.warning(message, error: error, stackTrace: stackTrace);
}

void watchdogError(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  Watchdog.error(message, error: error, stackTrace: stackTrace);
}
