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

  /// Kurslar katalogi qidiruvi (to‘liq ekran)
  static const String coursesSearch = '/courses-search';
  static const String coursesSearchName = 'coursesSearch';

  static const String myCertificates = '/my-certificates';
  static const String myCertificatesName = 'myCertificates';

  static const String vacancies = '/vacancies';
  static const String vacanciesName = 'vacancies';

  static const String vacancyDetailName = 'vacancyDetail';

  static String vacancyDetailPath(String vacancyId) => '/vacancies/$vacancyId';

  /// Profil ma'lumotlarini tahrirlash
  static const String profileInformation = '/profile/information';
  static const String profileInformationName = 'profileInformation';

  /// Biz haqimizda
  static const String aboutUs = '/about-us';
  static const String aboutUsName = 'aboutUs';

  /// Maxfiylik siyosati
  static const String privacyPolicy = '/privacy-policy';
  static const String privacyPolicyName = 'privacyPolicy';

  /// Market (do'kon)
  static const String store = '/store';
  static const String storeName = 'store';

  static String storeDetail(String id) => '/store/$id';
  static const String storeDetailName = 'storeDetail';

  static const String storeHistory = '/store-history';
  static const String storeHistoryName = 'storeHistory';

  static String storeOrderDetail(String orderId) => '/store-history/$orderId';
  static const String storeOrderDetailName = 'storeOrderDetail';

  static const String referral = '/referral';
  static const String referralName = 'referral';

  /// Mening faolligim (haftalik / oylik statistikasi).
  static const String myActivity = '/my-activity';
  static const String myActivityName = 'myActivity';

  static const String portfolio = '/portfolio';
  static const String portfolioName = 'portfolio';

  static String portfolioDetailPath(String postId) => '/portfolio/$postId';
  static const String portfolioDetailName = 'portfolioDetail';

  static const String portfolioCreate = '/portfolio/create';
  static const String portfolioCreateName = 'portfolioCreate';
}
