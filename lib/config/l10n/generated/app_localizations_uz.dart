// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Qizlar Akademiyasi';

  @override
  String get signInTitle => 'Kirish';

  @override
  String get signInSubtitle => 'Telefon raqamingizni kiriting';

  @override
  String get signInStart => 'Boshlash';

  @override
  String get orDivider => 'yoki';

  @override
  String get termsPrefix => 'Davom etib siz';

  @override
  String get termsLink => 'Foydalanuvchi shartlari';

  @override
  String get termsSuffix => 'ga rozilik bildirasiz.';

  @override
  String get comingSoonTitle => 'Tez orada';

  @override
  String get termsComingSoonMessage =>
      'Foydalanuvchi shartlari sahifasi keyingi bosqichda ochiladi.';

  @override
  String get signInPhoneTitle => 'Telefon raqam';

  @override
  String get signInPhoneIncompleteMessage =>
      'Iltimos, telefon raqamni to‘liq kiriting.';

  @override
  String get authPhoneOperatorRestrictedMessage => 'Bundan raqam mavjud emas!';

  @override
  String get authOtpTooManyRequestsMessage =>
      'Juda ko‘p urinish qildingiz. Birozdan keyin qayta urinib ko‘ring.';

  @override
  String get connectionErrorMessage =>
      'Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.';

  @override
  String get googleSignInErrorMessage =>
      'Google orqali kirishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.';

  @override
  String get telegramSignInInvalidLinkMessage =>
      'Telegramni ochib bo‘lmadi: serverdan noto‘g‘ri havola.';

  @override
  String get telegramSignInLaunchFailedMessage =>
      'Telegram ochilmadi. Qayta urinib ko‘ring.';

  @override
  String get telegramSignInOpenBotTitle => 'Telegram';

  @override
  String get telegramSignInEnterCodeHintMessage =>
      'Botni oching, keyin kelgan kodni shu yerga kiriting.';

  @override
  String get signInWithGoogle => 'Google bilan kirish';

  @override
  String get signInWithTelegram => 'Telegram bilan kirish';

  @override
  String get registerTitle => 'Shaxsiy ma\'lumotlar';

  @override
  String get registerSubtitle => 'Shaxsiy ma\'lumotlaringizni kiriting';

  @override
  String get firstNameHint => 'Ism';

  @override
  String get lastNameHint => 'Familya';

  @override
  String get registerContinue => 'Davom etish';

  @override
  String get enterFirstName => 'Ism kiriting';

  @override
  String get enterLastName => 'Familya kiriting';

  @override
  String get saveProfileErrorMessage =>
      'Ma\'lumotlarni saqlashda xatolik yuz berdi. Iltimos qayta urinib ko\'ring.';

  @override
  String get verificationTitle => 'Tasdiqlash kodi';

  @override
  String verificationCodeSentTo(String phone) {
    return 'Tasdiqlash kodini $phone raqamiga yuborildi.';
  }

  @override
  String get resendCode => 'Kodni qayta yuborish';

  @override
  String get resending => 'Yuborilmoqda...';

  @override
  String resendCodeCountdown(String time) {
    return 'Kodni qayta yuborish: $time';
  }

  @override
  String get otpDigitsOnlyMessage =>
      'Kod faqat raqamlardan iborat bo‘lishi kerak.';

  @override
  String get otpInvalidOrExpiredMessage =>
      'OTP kodi noto‘g‘ri yoki muddati o‘tgan.';

  @override
  String get otpSentAgain => 'Tasdiqlash kodi qayta yuborildi.';

  @override
  String get verificationBackConfirmTitle => 'Orqaga qaytishni xohlaysizmi?';

  @override
  String get verificationBackConfirmMessage =>
      'Chiqsangiz, kirishni davom ettirish uchun kodni qayta olishingiz kerak bo‘ladi.';

  @override
  String get verificationBackConfirmStay => 'Qolish';

  @override
  String get verificationBackConfirmLeave => 'Orqaga';

  @override
  String get mainTabHome => 'Asosiy';

  @override
  String get mainTabCourses => 'Kurslar';

  @override
  String get mainTabLeaderboard => 'Liderlar';

  @override
  String get mainTabProfile => 'Profil';

  @override
  String get guestSignInCta => 'Kirish';

  @override
  String get homeWelcomeGuestTitle => 'Xush kelibsiz!';

  @override
  String get homeWelcomeGuestSubtitle => 'Qizlar akademiyasiga';

  @override
  String get homeWelcomeBack => 'Xush kelibsiz!';

  @override
  String get homeRegisteredUserFallback => 'Ro‘yxatdan o‘tgan foydalanuvchi';

  @override
  String get homePopularCourses => 'Mashhur kurslar';

  @override
  String get homeGuestCoursesGate =>
      'Kurslarni to‘liq ko‘rish uchun ro‘yxatdan o‘ting';

  @override
  String get homeGuestNotificationsGate =>
      'Bildirishnomalar uchun ro‘yxatdan o‘ting';

  @override
  String get homeLoadErrorMessage =>
      'Ulanishda xatolik yuz berdi. Qayta urinib ko‘ring.';

  @override
  String get coursesCatalogLoadError =>
      'Kurslarni yuklashda xatolik yuz berdi.';

  @override
  String get leaderboardLoadError => 'Reytingni yuklashda xatolik.';

  @override
  String get profileOverviewLoadError =>
      'Profil ma\'lumotlarini yuklashda xatolik.';

  @override
  String get profilePreferenceUpdateError =>
      'Sozlamalarni yangilab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get notificationListLoadError =>
      'Bildirishnomalarni yuklashda xatolik yuz berdi.';

  @override
  String get notificationActionError =>
      'Bildirishnomalarni yangilashda xatolik yuz berdi.';

  @override
  String get courseDetailsLoadError =>
      'Kurs ma\'lumotlarini yuklashda xatolik.';

  @override
  String get courseDetailsShareTooltip => 'Kursni ulashish';

  @override
  String courseDetailsShareMessage(String title, String link) {
    return '$title\n$link';
  }

  @override
  String get editProfileLoadError =>
      'Profil ma\'lumotlarini yuklashda xatolik.';

  @override
  String get editProfileSaveError =>
      'Ma\'lumotlarni saqlab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get coursesAllTitle => 'Barcha kurslar';

  @override
  String get coursesSearchHint => 'Kurslarni izlash...';

  @override
  String get coursesSearchScreenTitle => 'Kurslarni qidirish';

  @override
  String get coursesSearchIdleHint => 'Qidiruv uchun kurs nomini kiriting';

  @override
  String get coursesNoResults => 'Mos kurs topilmadi';

  @override
  String get coursesNotificationsComingSoonMessage =>
      'Bildirishnomalar bo‘limi tez orada qo‘shiladi.';

  @override
  String get coursesLastViewed => 'Oxirgi ko‘rilgan';

  @override
  String get coursesInProgress => 'Jarayonda';

  @override
  String get courseEnroll => 'Kursga yozilish';

  @override
  String get courseEnrollConfirmTitle => 'Kursga yozilmoqchimisiz?';

  @override
  String get courseEnrollConfirmBody =>
      'Yozilgach, mavjud barcha darslarni ochib ko‘rishingiz mumkin.';

  @override
  String get courseEnrollConfirmPrimary => 'Yozilish';

  @override
  String get courseEnrollConfirmCancel => 'Bekor qilish';

  @override
  String get courseGuestFirstLessonCta => 'Birinchi darsni ko\'rish';

  @override
  String get courseGuestMoreLessonsTitle => 'Boshqa darslar uchun kiring';

  @override
  String get courseGuestMoreLessonsBody =>
      'Mehmon sifatida faqat birinchi darsni ko\'rishingiz mumkin. To\'liq kurs uchun tizimga kiring.';

  @override
  String get courseContinue => 'Davom etish';

  @override
  String courseTabLessons(int count) {
    return 'Darslar ($count)';
  }

  @override
  String get courseTabInfo => 'Ma\'lumot';

  @override
  String courseTabReviews(int count) {
    return 'Sharhlar ($count)';
  }

  @override
  String get lessonEmpty => 'Hali ochiq darslar yo‘q';

  @override
  String get lessonBackTooltip => 'Orqaga';

  @override
  String lessonProgress(int current, int total) {
    return 'Dars $current/$total';
  }

  @override
  String get lessonCompleted => 'Bajarildi';

  @override
  String get lessonMarkComplete => 'Darsni yakunlash';

  @override
  String get lessonVideoPlaybackError => 'Videoni yuklab bo\'lmadi.';

  @override
  String get lessonVideoPlaybackErrorYoutube =>
      'YouTube vaqtincha ilova ichida ijro etishni cheklashi mumkin. Videoni brauzer yoki YouTube ilovasida oching.';

  @override
  String get lessonVideoOpenExternal => 'Brauzerda ochish';

  @override
  String get coursePillTabLessons => 'Darslar';

  @override
  String get coursePillTabInfo => 'Ma\'lumot';

  @override
  String get coursePillTabReviews => 'Sharhlar';

  @override
  String get lessonQuizTestRowTitle => 'Test';

  @override
  String get lessonQuizGoToTest => 'Testga o\'tish';

  @override
  String get lessonQuizTitle => 'Test';

  @override
  String get lessonQuizQuestionLabel => 'Savol';

  @override
  String lessonQuizQuestionProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String lessonQuizPercentComplete(int percent) {
    return '$percent% yakunlangan';
  }

  @override
  String get lessonQuizTypeSingle => 'Bitta variant';

  @override
  String get lessonQuizTypeMultiple => 'Bir nechta variant';

  @override
  String get lessonQuizMark => 'Belgilash';

  @override
  String get lessonQuizNext => 'Keyingi';

  @override
  String get lessonQuizFinish => 'Yakunlash';

  @override
  String get lessonQuizExitTitle => 'Testdan chiqmoqchimisiz?';

  @override
  String get lessonQuizExitBody =>
      'Agar hozir chiqsangiz, natijalaringiz saqlanmaydi.';

  @override
  String get lessonQuizExitStay => 'Qolish';

  @override
  String get lessonQuizExitLeave => 'Chiqish';

  @override
  String get lessonQuizResultGreat => 'Ajoyib natija!';

  @override
  String get lessonQuizResultPoor => 'Qoniqarsiz natija!';

  @override
  String get lessonQuizStatCorrect => 'To\'g\'ri';

  @override
  String get lessonQuizStatWrong => 'Xato';

  @override
  String get lessonQuizStatTime => 'Vaqt';

  @override
  String get lessonQuizContinue => 'Davom qilish';

  @override
  String get lessonQuizRetry => 'Qayta ishlash';

  @override
  String get lessonQuizErrorEmpty => 'Bu dars uchun test hali yo\'q.';

  @override
  String get lessonQuizErrorLoad => 'Testni yuklab bo\'lmadi.';

  @override
  String get lessonQuizErrorCheck => 'Javobni tekshirib bo\'lmadi.';

  @override
  String get lessonQuizErrorSubmit => 'Testni yuborib bo\'lmadi.';

  @override
  String get lessonQuizErrorGeneric => 'Xatolik yuz berdi.';

  @override
  String get lessonQuizAlreadyTaken =>
      'Siz bu testni allaqachon topshirgansiz. Qayta topshirish mumkin emas.';

  @override
  String get courseModuleLockedMessage =>
      'Keyingi modulga o‘tish uchun avvalgi moduldagi barcha dars va testlarni yakunlang.';

  @override
  String get courseLessonSequentialLockedMessage =>
      'Keyingi darsga o‘tish uchun avvalgi darsni yakunlang va testini topshiring (test bo‘lsa).';

  @override
  String get courseCompleteCongratsTitle => 'Tabriklaymiz!';

  @override
  String get courseCompleteCongratsDescription =>
      'Siz bu kursni muvaffaqiyatli tugatdingiz. Sertifikatingizni «Sertifikatlarim» bo‘limidan oling.';

  @override
  String get courseCompleteGetCertificate => 'Sertifikatni olish';

  @override
  String get courseCompleteClose => 'Yopish';

  @override
  String get leaderboardTitle => 'Peshqadamlar';

  @override
  String get leaderboardSubtitle => 'Eng yaxshi o\'quvchilar reytingi';

  @override
  String get leaderboardTabOverall => 'Umumiy';

  @override
  String get leaderboardTabWeekly => 'Haftalik';

  @override
  String get leaderboardTabMonthly => 'Oylik';

  @override
  String get leaderboardSelectCourse => 'Kursni tanlang';

  @override
  String get leaderboardFullRanking => 'To\'liq reyting';

  @override
  String get leaderboardNoCourses => 'Hozircha kurslar topilmadi';

  @override
  String get refresh => 'Yangilash';

  @override
  String get leaderboardNoRatingYet => 'Bu kurs bo‘yicha hozircha reyting yo‘q';

  @override
  String get promotionTitle => 'Siz ham qatnashing!';

  @override
  String get promotionSubtitle => 'Kurslarni yakunlab ball to\'plang';

  @override
  String get promotionStart => 'Boshlash';

  @override
  String get profileStatCourses => 'Kurslar';

  @override
  String get profileStatCertificates => 'Sertifikatlar';

  @override
  String get profileStatRating => 'Reyting';

  @override
  String get profileStatPoints => 'Ballar';

  @override
  String get profileMenuCertificates => 'Sertifikatlarim';

  @override
  String get profileMenuMyCourses => 'Mening kurslarim';

  @override
  String get profileMenuMyActivity => 'Mening faolligim';

  @override
  String get profileMenuVacancies => 'Vakansiyalar';

  @override
  String get vacanciesTitle => 'Vakansiyalar';

  @override
  String get vacancyDetailCta => 'Batafsil';

  @override
  String get vacancySalaryNegotiable => 'Maosh kelishiladi';

  @override
  String vacancySalaryRange(String from, String to, String currency) {
    return '$from – $to $currency';
  }

  @override
  String get vacancyPostedMomentsAgo => 'Hozirgina';

  @override
  String vacancyPostedMinutesAgo(int count) {
    return '$count daqiqa avval';
  }

  @override
  String vacancyPostedHoursAgo(int count) {
    return '$count soat avval';
  }

  @override
  String get vacancyPostedYesterday => 'Kecha';

  @override
  String vacancyPostedDaysAgo(int count) {
    return '$count kun avval';
  }

  @override
  String get vacancyEmploymentIntern => 'Amaliyot';

  @override
  String get vacancyEmploymentPartTime => 'Yarim stavka';

  @override
  String get vacancyEmploymentFullTime => 'To‘liq stavka';

  @override
  String get vacancyEmploymentRemote => 'Masofadan';

  @override
  String get vacancyEmploymentOnsite => 'Ofisda';

  @override
  String get vacancyEmploymentContract => 'Shartnoma';

  @override
  String get vacanciesEmptyTitle => 'Hozircha vakansiya yo‘q';

  @override
  String get vacanciesEmptySubtitle => 'Keyinroq qayta tekshiring';

  @override
  String get vacanciesLoadError => 'Vakansiyalarni yuklab bo‘lmadi';

  @override
  String get vacanciesLoadMoreError => 'Yana yuklashda xatolik';

  @override
  String get vacancyDetailsTitle => 'Vakansiya';

  @override
  String get vacancySheetEmploymentType => 'Ish turi';

  @override
  String get vacancySheetSalary => 'Maosh';

  @override
  String get vacancySheetLocation => 'Manzil';

  @override
  String get vacancySheetCategory => 'Yo‘nalish';

  @override
  String get vacancySheetPosted => 'E‘lon qilingan';

  @override
  String get vacancyDetailAbout => 'Vakansiya haqida';

  @override
  String get vacancyDetailSkills => 'Ko\'nikmalar';

  @override
  String get vacancyDetailRequirements => 'Majburiyatlar';

  @override
  String get vacancyApplyCta => 'Ariza berish';

  @override
  String get vacancySalaryPerMonth => '/ oyiga';

  @override
  String get vacancyDetailLoadError => 'Vakansiyani yuklab bo\'lmadi';

  @override
  String get vacancyApplyPlaceholder =>
      'Tez orada — ariza qabul qilish ulanadi';

  @override
  String get profileMenuProfileInfo => 'Profil ma\'lumotlari';

  @override
  String get profileMenuLanguage => 'Til';

  @override
  String get profileMenuShareApp => 'Ilovani ulashish';

  @override
  String get profileShareAppSubtitle => 'Do‘stlaringiz bilan ulashing';

  @override
  String profileShareAppMessage(String link) {
    return 'Qizlar Akademiyasi — ayol-qizlar uchun bepul o‘quv kurslari, faol hamjamiyat va rivojlanish imkoniyatlari barchasi bitta ilovada.\n\nYuklab oling va birga o‘rganing:\n$link';
  }

  @override
  String get profileMenuAbout => 'Biz haqimizda';

  @override
  String get profileMenuHelp => 'Yordam markazi';

  @override
  String get profileMenuPrivacy => 'Maxfiylik siyosati';

  @override
  String get profileSectionAccount => 'HISOB';

  @override
  String profileCertificatesCountSubtitle(int count) {
    return '$count ta sertifikat';
  }

  @override
  String profileActiveCoursesCountSubtitle(int count) {
    return '$count ta aktiv kurslar';
  }

  @override
  String get profileSectionSettings => 'SOZLAMALAR';

  @override
  String get profileSectionGeneral => 'UMUMIY';

  @override
  String get profileNotifications => 'Bildirishnomalar';

  @override
  String get profileNotificationsSubtitle => 'Push-xabarlar';

  @override
  String get profileNotificationsEnableFailed =>
      'Bildirishnomalarni yoqib bo‘lmadi. Ruxsatlarni tekshiring va qayta urinib ko‘ring.';

  @override
  String get profileDarkMode => 'Tungi rejim';

  @override
  String get profileDarkModeSubtitle => 'Qorong\'i interfeys';

  @override
  String get profileLogout => 'Chiqish';

  @override
  String get profileLogoutConfirmTitle => 'Ilovadan chiqmoqchimisiz?';

  @override
  String get profileLogoutConfirmBody =>
      'Biz sizni yangi darslarda kutib qolamiz.\nHozir tizimdan chiqmoqchimisiz?';

  @override
  String get profileLogoutStay => 'Qolish';

  @override
  String profileVersion(String version) {
    return 'Versiya $version';
  }

  @override
  String get profileDataMissing => 'Profil ma\'lumotlari mavjud emas.';

  @override
  String get profileInformationTitle => 'Tahrirlash';

  @override
  String get profileInformationSave => 'Saqlash';

  @override
  String get profileInformationSaveSuccess => 'Profil yangilandi';

  @override
  String get profileInformationNameRequired => 'Ism va familiyangizni kiriting';

  @override
  String get profileInformationNoChanges => 'Saqlash uchun o‘zgarish yo‘q';

  @override
  String get profileInformationPhotoUploadFailed =>
      'Rasmni yuklab bo‘lmadi. Qayta urinib ko‘ring.';

  @override
  String get profileInformationPhotoPermissionDenied =>
      'Rasmga kirish o‘chiq. Sozlamalarda yoqishingiz mumkin.';

  @override
  String get profileInformationPhotoPickFailed =>
      'Rasmni tanlab bo‘lmadi. Qayta urinib ko‘ring.';

  @override
  String get profileInformationStatusTitle => 'Profil status';

  @override
  String get profileInformationPhoneLabel => 'Telefon raqami';

  @override
  String get profileInformationPhoneNationalHint => 'XX XXX XX XX';

  @override
  String get editProfileUnsavedTitle => 'Saqlanmagan o‘zgarishlar';

  @override
  String get editProfileUnsavedMessage =>
      'Profilda saqlanmagan o‘zgarishlar bor. Chiqishdan oldin ularni saqlaysizmi?';

  @override
  String get editProfileUnsavedSave => 'Saqlash';

  @override
  String get editProfileUnsavedDiscard => 'Saqlamasdan chiqish';

  @override
  String get editProfileUnsavedContinue => 'Tahrirlashni davom ettirish';

  @override
  String get aboutBrandTitle => 'QIZLAR AKADEMIYASI';

  @override
  String get aboutSectionProjectTitle => 'Qizlar Akademiyasi loyihasi haqida';

  @override
  String get aboutProjectLead => 'Qizlar akademiyasi';

  @override
  String get aboutProjectBody =>
      ' – barcha yoshdagi xotin-qizlar uchun bepul o\'quv kurslarni o\'z ichiga jamlagan interaktiv platforma. Platforma o\'z ichiga salomatlik, zamonaviy kasblar, hunarmandchilik, ta\'lim, tadbirkorlik, psixologik hamda huquqiy yo\'nalishlarni o\'z ichiga olgan. Ro\'yxatdan o\'ting va platforma orqali turli yo\'nalishlarda bilim va ko\'nikmangizni oshirib boring.';

  @override
  String get aboutSectionSupportersTitle => 'Bizni qo\'llab-quvvatlamoqda';

  @override
  String get aboutSupporterSadullaName => 'Alisher Sadullayev';

  @override
  String get aboutSupporterSadullaRole =>
      'O\'zbekiston Respublikasi Yoshlar ishlari agentligi direktori';

  @override
  String get aboutSupporterKattaxonName => 'Dilnoza Kattaxonova';

  @override
  String get aboutSupporterKattaxonRole =>
      'Yoshlar ishlari agentligi direktorining birinchi o\'rinbosari. Siyosiy fanlar bo\'yicha falsafa doktori';

  @override
  String get aboutSectionSocialTitle => 'Ijtimoiy tarmoqlar';

  @override
  String get aboutSocialInstagramTitle => 'Instagram';

  @override
  String get aboutSocialInstagramSubtitle =>
      'Qizlar Akademiyasi rasmiy Instagram kanali';

  @override
  String get aboutSocialTelegramTitle => 'Telegram';

  @override
  String get aboutSocialTelegramSubtitle =>
      'Qizlar Akademiyasi rasmiy Telegram kanali';

  @override
  String get aboutSocialYoutubeTitle => 'Youtube';

  @override
  String get aboutSocialYoutubeSubtitle =>
      'Qizlar Akademiyasi rasmiy Youtube kanali';

  @override
  String get aboutUsLoadError => 'Ma\'lumot yuklanmadi. Qayta urinib ko\'ring.';

  @override
  String get aboutUsLinkOpenError => 'Havolani ochib bo\'lmadi.';

  @override
  String get appUpdateAvailableTitle => 'Yangilanish mavjud!';

  @override
  String get appUpdateAvailableBody =>
      'Biz ilovani yanada yaxshiladik! Yangi imkoniyatlardan foydalanish va qulayroq o‘qish uchun ilovani yangilang.';

  @override
  String get appUpdateLater => 'Keyinroq';

  @override
  String get appUpdateCta => 'Yangilash';

  @override
  String get guestGateNotificationSettings =>
      'Bildirishnoma sozlamalari uchun ro‘yxatdan o‘ting';

  @override
  String get guestGateSaveSettings =>
      'Sozlamalarni saqlash uchun ro‘yxatdan o‘ting';

  @override
  String get guestGateProfileFeatures =>
      'Profil funksiyalari uchun ro‘yxatdan o‘ting';

  @override
  String get profileAppLanguageTitle => 'Ilova tili';

  @override
  String get profileBadgePickerTitle => 'Mening nishonlarim';

  @override
  String get profileTezKundaTitle => 'Tez kunda';

  @override
  String get profileTezKundaMessage =>
      'Bu bo‘lim hozircha mavjud emas. U ustida ishlayapmiz — tez orada qaytib keling.';

  @override
  String get languageUzbek => 'O\'zbekcha';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get notificationsTitle => 'Bildirishnoma';

  @override
  String get notificationsEmpty => 'Hozircha bildirishnomalar yo\'q';

  @override
  String get notificationsEmptySubtitle =>
      'Yangi xabarlar paydo bo\'lishi bilan shu yerda ko\'rinadi.';

  @override
  String get notificationTabPlatform => 'Platforma';

  @override
  String get notificationTabCommunity => 'Jamiyat';

  @override
  String get notificationDetailsMore => 'Batafsil';

  @override
  String get notificationsEmptyThisTab =>
      'Ushbu bo‘limda bildirishnomalar yo‘q';

  @override
  String get notificationsEmptyThisTabSubtitle =>
      'Boshqa yorliqqa o‘ting yoki keyinroq qaytib keling.';

  @override
  String get guestGateMarkAllRead =>
      'Barchasini o‘qilgan qilish uchun ro‘yxatdan o‘ting';

  @override
  String get guestGateManageNotifications =>
      'Bildirishnomalarni boshqarish uchun ro‘yxatdan o‘ting';

  @override
  String get guestModeTitle => 'Mehmon rejimi';

  @override
  String get guestModeDescription =>
      'Barcha imkoniyatlardan foydalanish uchun akkaunt\nyarating yoki tizimga kiring.';

  @override
  String get errorGeneric => 'Xatolik yuz berdi';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get homeGuestCardSignIn => 'Kirish';

  @override
  String get myCoursesTitle => 'Mening kurslarim';

  @override
  String myCoursesRatingReviewsLine(String rating, String reviewsCount) {
    return '$rating ($reviewsCount izohlar)';
  }

  @override
  String myCoursesDurationHours(int hours) {
    return '$hours soat';
  }

  @override
  String get myCoursesEmptyTitle => 'Hozircha kurslar yo\'q';

  @override
  String get myCoursesEmptySubtitle =>
      'Kursga yoziling — u shu yerda paydo bo\'ladi.';

  @override
  String get myCoursesLoadError =>
      'Kurslarni yuklab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get myCoursesLoadMoreError =>
      'Yana yuklab bo\'lmadi. Qayta scroll qiling.';

  @override
  String get certificatesBadgeGold => 'Oltin sertifikat';

  @override
  String get certificatesBadgeSilver => 'Kumush sertifikat';

  @override
  String get certificatesBadgeBronze => 'Bronza sertifikat';

  @override
  String get linkPromptYes => 'Ha';

  @override
  String get linkPromptNo => 'Yo\'q';

  @override
  String get communityTelegramInviteTitle => 'Bizning hamjamiyatga qo‘shiling';

  @override
  String get communityTelegramInviteDescription =>
      'Telegram kanalimizda barcha savollaringizga javob topishingiz mumkin. Telegram kanalimizga o‘tmoqchimisiz?';

  @override
  String get certificatesView => 'Ko\'rish';

  @override
  String certificatesSheetHeading(String courseName) {
    return '$courseName sertifikati';
  }

  @override
  String get certificatesSheetDescription =>
      'Siz kursni muvaffaqiyatli yakunladingiz va maxsus sertifikatga ega bo\'ldingiz. Bilimlaringiz doim hamroh bo\'lsin!';

  @override
  String get certificatesSheetDownload => 'Yuklab olish';

  @override
  String get certificatesEmptyTitle => 'Hozircha sertifikatlar yo\'q';

  @override
  String get certificatesEmptySubtitle =>
      'Kursni tugatganingizdan keyin sertifikatingiz shu yerda paydo bo\'ladi.';

  @override
  String get certificatesLoadError =>
      'Sertifikatlarni yuklab bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get certificateClaimError =>
      'Sertifikatni olishda xatolik. Keyinroq urinib ko\'ring.';

  @override
  String get certificatesFileActionError =>
      'Faylni yuklab yoki ulashib bo\'lmadi.';

  @override
  String get certificatesInstagramStoryNotConfigured =>
      'Instagram Story uchun Facebook App ID kerak. Ilovani yig‘ishda FACEBOOK_APP_ID qo‘shing.';

  @override
  String get certificatesInstagramShareFailed =>
      'Instagram ochilmadi. Instagram o‘rnatilganligini tekshirib, qayta urinib ko‘ring.';

  @override
  String courseReviewsSummaryCount(int count) {
    return '$count ta sharh';
  }

  @override
  String get courseReviewsEmptyTitle => 'Hozircha sharhlar yo\'q';

  @override
  String get courseReviewsEmptySubtitle =>
      'O\'quvchilar fikr qoldirganda, ular shu yerda ko\'rinadi.';

  @override
  String get courseLeaveReviewCta => 'Izoh qoldirish';

  @override
  String get courseSubmitReviewTitle => 'Sharh qoldirish';

  @override
  String get courseSubmitReviewRateTitle => 'Kursni baholang';

  @override
  String get courseSubmitReviewRateSubtitle =>
      'Olingan bilimlar va dars sifati haqida nima deysiz? O\'z fikringizni yozib qoldiring.';

  @override
  String get courseSubmitReviewYourCommentLabel => 'Sharhingiz';

  @override
  String get courseSubmitReviewCommentHint =>
      'Kurs sizga yoqdimi? Taassurotlaringiz bilan o\'rtoqlashing';

  @override
  String courseSubmitReviewCharCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String get courseSubmitReviewSubmit => 'Sharhni yuborish';

  @override
  String get courseSubmitReviewSuccess => 'Sharhingiz yuborildi';

  @override
  String get courseSubmitReviewError =>
      'Sharhni yuborib bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get courseSubmitReviewSelectRating => 'Iltimos, kursni baholang';

  @override
  String get reviewTimeJustNow => 'Hozirgina';

  @override
  String reviewTimeMinutesAgo(int count) {
    return '$count daqiqa oldin';
  }

  @override
  String reviewTimeHoursAgo(int count) {
    return '$count soat oldin';
  }

  @override
  String reviewTimeDaysAgo(int count) {
    return '$count kun oldin';
  }

  @override
  String reviewTimeWeeksAgo(int count) {
    return '$count hafta oldin';
  }

  @override
  String reviewTimeMonthsAgo(int count) {
    return '$count oy oldin';
  }

  @override
  String reviewTimeYearsAgo(int count) {
    return '$count yil oldin';
  }
}
