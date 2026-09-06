import 'package:watchdog/watchdog.dart';

/// Maps [MainScreen] PageView indices to the widget class on that tab.
String mainTabScreenName(int index, {required bool isGuestMode}) {
  if (isGuestMode) {
    return switch (index) {
      0 => 'HomeScreen',
      1 => 'SignInScreen',
      2 => 'LeaderboardScreen',
      3 => 'SignInScreen',
      _ => 'HomeScreen',
    };
  }
  return switch (index) {
    0 => 'HomeScreen',
    1 => 'StoreScreen',
    2 => 'LeaderboardScreen',
    3 => 'ProfileScreen',
    _ => 'HomeScreen',
  };
}

/// Default tab when `/main/user` or `/main/guest` is first built.
const String kMainTabInitialScreenName = 'HomeScreen';

String? _lastReportedTabScreen = kMainTabInitialScreenName;

/// Emits a Watchdog route replace for a bottom-tab change.
///
/// Tabs are not GoRoutes, so [Watchdog.routeObserver] never sees them.
void reportWatchdogMainTab(
  int index, {
  required bool isGuestMode,
  String? path,
}) {
  final screenName = mainTabScreenName(index, isGuestMode: isGuestMode);
  if (screenName == _lastReportedTabScreen) return;
  final previous = _lastReportedTabScreen;
  _lastReportedTabScreen = screenName;

  final observer = Watchdog.routeObserver;
  final stack = List<String>.from(observer.currentStack);
  if (stack.isEmpty) {
    stack.add(screenName);
  } else {
    stack[stack.length - 1] = screenName;
  }

  observer.broadcaster.broadcastRoute(
    RouteEvent(
      id: 'tab-${DateTime.now().microsecondsSinceEpoch}-$screenName',
      timestamp: DateTime.now(),
      action: RouteAction.replace,
      routeName: screenName,
      routeType: 'MainTab',
      previousRouteName: previous,
      fullStack: stack,
      arguments: path,
    ),
  );
}
