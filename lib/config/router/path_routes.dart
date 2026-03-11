part of 'app_routes.dart';

/// Route path constants — barcha path'lar bitta joyda.
sealed class Routes {
  Routes._();

  /// Splash (boshlang'ich ekran)
  static const String splash = '/';

  /// Asosiy shell (pastki tab bar bilan)
  static const String main = '/main';

  /// Bosh sahifa
  static const String home = '/home';
}
