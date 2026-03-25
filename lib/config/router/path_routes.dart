part of 'app_routes.dart';

/// Route path constants — barcha path'lar bitta joyda.
sealed class Routes {
  Routes._();

  /// Splash (boshlang'ich ekran)
  static const String splash = '/';

  /// Asosiy shell (pastki tab bar bilan)
  static const String main = '/main';

  /// Sign in
  static const String signIn = '/sign-in';
  static const String verification = '/verification';

  /// Shaxsiy ma'lumotlar (ro'yxatdan o'tmagan foydalanuvchi uchun)
  static const String register = '/register';

  /// Kurs detallari (id bilan)
  static String courseDetails(String id) => '/courses/$id';
  static String coursePlayer(String id) => '/courses/$id/player';

  /// Bildirishnomalar ro'yxati
  static const String notification = '/notification';
  static const String notificationName = 'notification';
}
