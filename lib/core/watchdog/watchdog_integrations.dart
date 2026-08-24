import 'package:qizlar_academy_kit/qizlar_academy_kit.dart'
    show Dio, GetIt, NavigatorObserver;
import 'package:watchdog/watchdog.dart';

/// Adds Watchdog's Dio interceptor if it isn't already attached.
///
/// Call this **after** the app's own interceptors so the captured request
/// carries the final headers (auth, retries) rather than a half-built one.
void attachWatchdogToDio(Dio dio) {
  if (!dio.interceptors.contains(Watchdog.dioInterceptor)) {
    dio.interceptors.add(Watchdog.dioInterceptor);
  }
}

/// Observers to hand to `GoRouter(observers: ...)` (or `MaterialApp`).
List<NavigatorObserver> watchdogRouterObservers([
  List<NavigatorObserver> existing = const [],
]) {
  return [...existing, Watchdog.routeObserver];
}

/// Reports the registered dependencies to the dashboard's Instances tab.
///
/// `instantiateLazy` is deliberately off: the default (`true`) force-creates
/// every lazy singleton, which would defeat this app's staged startup.
void trackWatchdogGetIt(GetIt getIt) {
  Watchdog.trackGetIt(getIt, instantiateLazy: false);
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

void watchdogError(String message, {Object? error, StackTrace? stackTrace}) {
  Watchdog.error(message, error: error, stackTrace: stackTrace);
}
