part of 'app_routes.dart';

/// Route path constants — barcha path'lar bitta joyda.
sealed class Routes {
  Routes._();

  /// Splash (boshlang'ich ekran)
  static const String splash = '/';

  /// Asosiy shell (pastki tab bar bilan)
  static const String main = '/main';
  static const String mainGuest = '/main/guest';
  static const String mainUser = '/main/user';

  /// Sign in
  static const String signIn = '/sign-in';
  static const String verification = '/verification';

  /// Shaxsiy ma'lumotlar (ro'yxatdan o'tmagan foydalanuvchi uchun)
  static const String register = '/register';

  /// Kurs detallari (id bilan)
  static String courseDetails(String id) => '/courses/$id';
  static String coursePlayer(String id) => '/courses/$id/player';

  /// Kursga sharh qoldirish
  static String courseSubmitReview(String id) => '/courses/$id/review';
  static const String courseSubmitReviewName = 'courseSubmitReview';

  /// Dars testi (savollar)
  static String lessonQuiz(String lessonId) => '/lesson-quiz/$lessonId';

  /// Test natijasi ([LessonQuizResultArgs] — `extra`)
  static const String lessonQuizResult = '/lesson-quiz-result';
  static const String lessonQuizResultName = 'lessonQuizResult';

  /// Bildirishnomalar ro'yxati
  static const String notification = '/notification';
  static const String notificationName = 'notification';

  /// Ro'yxatdan o'tgan foydalanuvchining kurslari
  static const String myCourses = '/my-courses';
  static const String myCoursesName = 'myCourses';

  static const String myCertificates = '/my-certificates';
  static const String myCertificatesName = 'myCertificates';

  /// Profil ma'lumotlarini tahrirlash
  static const String profileInformation = '/profile/information';
  static const String profileInformationName = 'profileInformation';

  /// Biz haqimizda
  static const String aboutUs = '/about-us';
  static const String aboutUsName = 'aboutUs';
}
