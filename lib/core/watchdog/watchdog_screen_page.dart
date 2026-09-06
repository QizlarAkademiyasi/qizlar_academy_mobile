import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Page whose [Page.name] is the Flutter screen widget class.
///
/// [Watchdog.routeObserver] reads `RouteSettings.name`. GoRouter otherwise
/// puts `GoRoute.name` or the URL path there (`portfolio`, `/sign-in`), not
/// `PortfolioScreen`.
Page<void> watchdogScreenPage({
  required GoRouterState state,
  required String screenName,
  required Widget child,
}) {
  return MaterialPage<void>(
    key: state.pageKey,
    name: screenName,
    arguments: <String, String>{'path': state.uri.path},
    child: child,
  );
}
