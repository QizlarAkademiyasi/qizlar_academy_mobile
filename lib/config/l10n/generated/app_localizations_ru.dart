// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Академия Qizlar';

  @override
  String get signInTitle => 'Вход';

  @override
  String get signInSubtitle => 'Введите номер телефона';

  @override
  String get signInStart => 'Начать';

  @override
  String get orDivider => 'или';

  @override
  String get termsPrefix => 'Продолжая, вы принимаете';

  @override
  String get termsLink => 'Пользовательское соглашение';

  @override
  String get termsSuffix => '.';

  @override
  String get comingSoonTitle => 'Скоро';

  @override
  String get termsComingSoonMessage =>
      'Страница условий откроется в следующем обновлении.';

  @override
  String get signInPhoneTitle => 'Номер телефона';

  @override
  String get signInPhoneIncompleteMessage =>
      'Пожалуйста, введите полный номер телефона.';

  @override
  String get authPhoneOperatorRestrictedMessage =>
      'Этот номер не поддерживается для SMS.';

  @override
  String get authOtpTooManyRequestsMessage =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get connectionErrorMessage => 'Ошибка соединения. Попробуйте ещё раз.';

  @override
  String get googleSignInErrorMessage =>
      'Не удалось войти через Google. Попробуйте ещё раз.';

  @override
  String get telegramSignInComingSoonMessage =>
      'Вход через Telegram будет доступен позже.';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get signInWithTelegram => 'Войти через Telegram';

  @override
  String get registerTitle => 'Личные данные';

  @override
  String get registerSubtitle => 'Введите личные данные';

  @override
  String get firstNameHint => 'Имя';

  @override
  String get lastNameHint => 'Фамилия';

  @override
  String get registerContinue => 'Продолжить';

  @override
  String get enterFirstName => 'Введите имя';

  @override
  String get enterLastName => 'Введите фамилию';

  @override
  String get saveProfileErrorMessage =>
      'Не удалось сохранить данные. Попробуйте ещё раз.';

  @override
  String get verificationTitle => 'Код подтверждения';

  @override
  String verificationCodeSentTo(String phone) {
    return 'Код подтверждения отправлен на номер $phone.';
  }

  @override
  String get resendCode => 'Отправить код снова';

  @override
  String get resending => 'Отправка…';

  @override
  String resendCodeCountdown(String time) {
    return 'Повторная отправка: $time';
  }

  @override
  String get otpDigitsOnlyMessage => 'Код должен содержать только цифры.';

  @override
  String get otpInvalidOrExpiredMessage =>
      'Неверный код или срок его действия истёк.';

  @override
  String get otpSentAgain => 'Код подтверждения отправлен повторно.';

  @override
  String get mainTabHome => 'Главная';

  @override
  String get mainTabCourses => 'Курсы';

  @override
  String get mainTabLeaderboard => 'Лидеры';

  @override
  String get mainTabProfile => 'Профиль';

  @override
  String get guestSignInCta => 'Войти';

  @override
  String get homeWelcomeGuestTitle => 'Добро пожаловать!';

  @override
  String get homeWelcomeGuestSubtitle => 'в Академию Qizlar';

  @override
  String get homeWelcomeBack => 'Добро пожаловать!';

  @override
  String get homeRegisteredUserFallback => 'Зарегистрированный пользователь';

  @override
  String get homePopularCourses => 'Популярные курсы';

  @override
  String get homeGuestCoursesGate =>
      'Зарегистрируйтесь, чтобы полностью смотреть курсы';

  @override
  String get homeGuestNotificationsGate => 'Зарегистрируйтесь для уведомлений';

  @override
  String get homeLoadErrorMessage => 'Ошибка соединения. Попробуйте ещё раз.';

  @override
  String get coursesAllTitle => 'Все курсы';

  @override
  String get coursesSearchHint => 'Поиск курсов…';

  @override
  String get coursesNoResults => 'Подходящих курсов нет';

  @override
  String get coursesNotificationsComingSoonMessage =>
      'Раздел уведомлений скоро появится.';

  @override
  String get coursesLastViewed => 'Недавно просмотренные';

  @override
  String get coursesInProgress => 'В процессе';

  @override
  String get courseEnroll => 'Записаться на курс';

  @override
  String get courseEnrollConfirmTitle => 'Записаться на курс?';

  @override
  String get courseEnrollConfirmBody =>
      'После записи вы сможете открывать и смотреть все доступные уроки.';

  @override
  String get courseEnrollConfirmPrimary => 'Записаться';

  @override
  String get courseEnrollConfirmCancel => 'Отмена';

  @override
  String get courseGuestFirstLessonCta => 'Смотреть первый урок';

  @override
  String get courseGuestMoreLessonsTitle => 'Войдите для остальных уроков';

  @override
  String get courseGuestMoreLessonsBody =>
      'Гости могут смотреть только первый урок. Войдите, чтобы открыть весь курс.';

  @override
  String get courseContinue => 'Продолжить';

  @override
  String courseTabLessons(int count) {
    return 'Уроки ($count)';
  }

  @override
  String get courseTabInfo => 'О курсе';

  @override
  String courseTabReviews(int count) {
    return 'Отзывы ($count)';
  }

  @override
  String get lessonEmpty => 'Пока нет доступных уроков';

  @override
  String get lessonBackTooltip => 'Назад';

  @override
  String lessonProgress(int current, int total) {
    return 'Урок $current из $total';
  }

  @override
  String get lessonCompleted => 'Выполнено';

  @override
  String get lessonMarkComplete => 'Завершить урок';

  @override
  String get coursePillTabLessons => 'Уроки';

  @override
  String get coursePillTabInfo => 'О курсе';

  @override
  String get coursePillTabReviews => 'Отзывы';

  @override
  String get lessonQuizTestRowTitle => 'Тест';

  @override
  String get lessonQuizGoToTest => 'Перейти к тесту';

  @override
  String get lessonQuizTitle => 'Тест';

  @override
  String get lessonQuizQuestionLabel => 'Вопрос';

  @override
  String lessonQuizQuestionProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String lessonQuizPercentComplete(int percent) {
    return '$percent% завершено';
  }

  @override
  String get lessonQuizTypeSingle => 'Один вариант';

  @override
  String get lessonQuizTypeMultiple => 'Несколько вариантов';

  @override
  String get lessonQuizMark => 'Отметить';

  @override
  String get lessonQuizNext => 'Далее';

  @override
  String get lessonQuizFinish => 'Завершить';

  @override
  String get lessonQuizExitTitle => 'Выйти из теста?';

  @override
  String get lessonQuizExitBody =>
      'Если выйти сейчас, результаты не сохранятся.';

  @override
  String get lessonQuizExitStay => 'Остаться';

  @override
  String get lessonQuizExitLeave => 'Выйти';

  @override
  String get lessonQuizResultGreat => 'Отличный результат!';

  @override
  String get lessonQuizResultPoor => 'Результат неудовлетворительный';

  @override
  String get lessonQuizStatCorrect => 'Верно';

  @override
  String get lessonQuizStatWrong => 'Ошибки';

  @override
  String get lessonQuizStatTime => 'Время';

  @override
  String get lessonQuizContinue => 'Продолжить';

  @override
  String get lessonQuizErrorEmpty => 'Для этого урока пока нет теста.';

  @override
  String get lessonQuizErrorLoad => 'Не удалось загрузить тест.';

  @override
  String get lessonQuizErrorCheck => 'Не удалось проверить ответ.';

  @override
  String get lessonQuizErrorSubmit => 'Не удалось отправить тест.';

  @override
  String get lessonQuizErrorGeneric => 'Что-то пошло не так.';

  @override
  String get lessonQuizAlreadyTaken =>
      'Вы уже прошли этот тест. Повторная попытка недоступна.';

  @override
  String get leaderboardTitle => 'Лидеры';

  @override
  String get leaderboardSubtitle => 'Рейтинг лучших учеников';

  @override
  String get leaderboardTabOverall => 'Общий';

  @override
  String get leaderboardTabWeekly => 'Неделя';

  @override
  String get leaderboardTabMonthly => 'Месяц';

  @override
  String get leaderboardSelectCourse => 'Выберите курс';

  @override
  String get leaderboardFullRanking => 'Полный рейтинг';

  @override
  String get leaderboardNoCourses => 'Курсов пока нет';

  @override
  String get refresh => 'Обновить';

  @override
  String get leaderboardNoRatingYet => 'По этому курсу пока нет рейтинга';

  @override
  String get promotionTitle => 'Участвуйте и вы!';

  @override
  String get promotionSubtitle => 'Завершайте курсы и зарабатывайте баллы';

  @override
  String get promotionStart => 'Начать';

  @override
  String get profileStatCourses => 'Курсы';

  @override
  String get profileStatCertificates => 'Сертификаты';

  @override
  String get profileStatRating => 'Рейтинг';

  @override
  String get profileStatPoints => 'Баллы';

  @override
  String get profileMenuCertificates => 'Мои сертификаты';

  @override
  String get profileMenuMyCourses => 'Мои курсы';

  @override
  String get profileMenuMyActivity => 'Моя активность';

  @override
  String get profileMenuProfileInfo => 'Данные профиля';

  @override
  String get profileMenuLanguage => 'Язык';

  @override
  String get profileMenuShareApp => 'Поделиться приложением';

  @override
  String get profileMenuAbout => 'О нас';

  @override
  String get profileMenuHelp => 'Центр помощи';

  @override
  String get profileMenuPrivacy => 'Политика конфиденциальности';

  @override
  String get profileSectionAccount => 'АККАУНТ';

  @override
  String profileCertificatesCountSubtitle(int count) {
    return '$count сертификатов';
  }

  @override
  String profileActiveCoursesCountSubtitle(int count) {
    return '$count активных курсов';
  }

  @override
  String get profileSectionSettings => 'НАСТРОЙКИ';

  @override
  String get profileSectionGeneral => 'ОБЩЕЕ';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileNotificationsSubtitle => 'Push-уведомления';

  @override
  String get profileDarkMode => 'Тёмная тема';

  @override
  String get profileDarkModeSubtitle => 'Тёмный интерфейс';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileLogoutConfirmTitle => 'Выйти из приложения?';

  @override
  String get profileLogoutConfirmBody =>
      'Мы будем ждать вас на новых уроках.\nВыйти из системы сейчас?';

  @override
  String get profileLogoutStay => 'Остаться';

  @override
  String profileVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get profileDataMissing => 'Данные профиля недоступны.';

  @override
  String get profileInformationTitle => 'Редактирование';

  @override
  String get profileInformationSave => 'Сохранить';

  @override
  String get profileInformationSaveSuccess => 'Профиль обновлён';

  @override
  String get profileInformationNameRequired => 'Введите имя и фамилию';

  @override
  String get profileInformationNoChanges => 'Нет изменений для сохранения';

  @override
  String get profileInformationPhotoUploadFailed =>
      'Не удалось загрузить фото. Попробуйте снова.';

  @override
  String get profileInformationPhotoPermissionDenied =>
      'Доступ к фото отключён. Включите его в настройках.';

  @override
  String get profileInformationPhotoPickFailed =>
      'Не удалось выбрать фото. Попробуйте снова.';

  @override
  String get profileInformationStatusTitle => 'Статус профиля';

  @override
  String get profileInformationPhoneLabel => 'Номер телефона';

  @override
  String get profileInformationPhoneNationalHint => 'XX XXX XX XX';

  @override
  String get aboutBrandTitle => 'QIZLAR AKADEMIYASI';

  @override
  String get aboutSectionProjectTitle => 'О проекте Qizlar Academy';

  @override
  String get aboutProjectLead => 'Qizlar Academy';

  @override
  String get aboutProjectBody =>
      ' — интерактивная платформа с бесплатными учебными курсами для женщин и девушек всех возрастов. Платформа объединяет направления: здоровье, современные профессии, ремёсла, образование, предпринимательство, психология и право. Зарегистрируйтесь и развивайте знания и навыки в разных сферах.';

  @override
  String get aboutSectionSupportersTitle => 'Нас поддерживают';

  @override
  String get aboutSupporterSadullaName => 'Алишер Садуллаев';

  @override
  String get aboutSupporterSadullaRole =>
      'Директор Агентства по делам молодёжи Республики Узбекистан';

  @override
  String get aboutSupporterKattaxonName => 'Дилноза Каттаханова';

  @override
  String get aboutSupporterKattaxonRole =>
      'Первый заместитель директора Агентства по делам молодёжи. Доктор философии по политическим наукам';

  @override
  String get aboutSectionSocialTitle => 'Социальные сети';

  @override
  String get aboutSocialInstagramTitle => 'Instagram';

  @override
  String get aboutSocialInstagramSubtitle =>
      'Официальный канал Qizlar Academy в Instagram';

  @override
  String get aboutSocialTelegramTitle => 'Telegram';

  @override
  String get aboutSocialTelegramSubtitle =>
      'Официальный канал Qizlar Academy в Telegram';

  @override
  String get aboutSocialYoutubeTitle => 'YouTube';

  @override
  String get aboutSocialYoutubeSubtitle =>
      'Официальный канал Qizlar Academy на YouTube';

  @override
  String get aboutUsLoadError =>
      'Не удалось загрузить данные. Попробуйте снова.';

  @override
  String get aboutUsLinkOpenError => 'Не удалось открыть ссылку.';

  @override
  String get guestGateNotificationSettings =>
      'Зарегистрируйтесь, чтобы настроить уведомления';

  @override
  String get guestGateSaveSettings =>
      'Зарегистрируйтесь, чтобы сохранить настройки';

  @override
  String get guestGateProfileFeatures =>
      'Зарегистрируйтесь для функций профиля';

  @override
  String get profileAppLanguageTitle => 'Язык приложения';

  @override
  String get languageUzbek => 'Узбекский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmpty => 'Пока нет уведомлений';

  @override
  String get notificationsEmptySubtitle => 'Новые сообщения появятся здесь.';

  @override
  String get guestGateMarkAllRead =>
      'Зарегистрируйтесь, чтобы отметить всё прочитанным';

  @override
  String get guestGateManageNotifications =>
      'Зарегистрируйтесь, чтобы управлять уведомлениями';

  @override
  String get guestModeTitle => 'Гостевой режим';

  @override
  String get guestModeDescription =>
      'Создайте аккаунт или войдите, чтобы пользоваться всеми возможностями.';

  @override
  String get errorGeneric => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get homeGuestCardSignIn => 'Войти';

  @override
  String get myCoursesTitle => 'Мои курсы';

  @override
  String myCoursesRatingReviewsLine(String rating, String reviewsCount) {
    return '$rating ($reviewsCount отзывов)';
  }

  @override
  String myCoursesDurationHours(int hours) {
    return '$hours ч';
  }

  @override
  String get myCoursesEmptyTitle => 'Пока нет курсов';

  @override
  String get myCoursesEmptySubtitle =>
      'Запишитесь на курс — он появится здесь.';

  @override
  String get myCoursesLoadError =>
      'Не удалось загрузить курсы. Попробуйте снова.';

  @override
  String get myCoursesLoadMoreError =>
      'Не удалось подгрузить. Прокрутите ещё раз.';

  @override
  String get certificatesBadgeGold => 'Золотой сертификат';

  @override
  String get certificatesBadgeSilver => 'Серебряный сертификат';

  @override
  String get certificatesBadgeBronze => 'Бронзовый сертификат';

  @override
  String get certificatesView => 'Смотреть';

  @override
  String certificatesSheetHeading(String courseName) {
    return 'Сертификат: $courseName';
  }

  @override
  String get certificatesSheetDescription =>
      'Вы успешно завершили курс и получили сертификат. Пусть знания всегда остаются с вами!';

  @override
  String get certificatesSheetDownload => 'Скачать';

  @override
  String get certificatesEmptyTitle => 'Пока нет сертификатов';

  @override
  String get certificatesEmptySubtitle =>
      'После завершения курса сертификат появится здесь.';

  @override
  String get certificatesLoadError =>
      'Не удалось загрузить сертификаты. Попробуйте снова.';

  @override
  String get certificatesFileActionError =>
      'Не удалось скачать или поделиться файлом.';

  @override
  String courseReviewsSummaryCount(int count) {
    return '$count отзывов';
  }

  @override
  String get courseReviewsEmptyTitle => 'Пока нет отзывов';

  @override
  String get courseReviewsEmptySubtitle =>
      'Когда ученики оставят отзывы, они появятся здесь.';

  @override
  String get courseLeaveReviewCta => 'Оставить отзыв';

  @override
  String get courseSubmitReviewTitle => 'Оставить отзыв';

  @override
  String get courseSubmitReviewRateTitle => 'Оцените курс';

  @override
  String get courseSubmitReviewRateSubtitle =>
      'Что скажете о полученных знаниях и качестве уроков? Поделитесь мнением.';

  @override
  String get courseSubmitReviewYourCommentLabel => 'Ваш отзыв';

  @override
  String get courseSubmitReviewCommentHint =>
      'Вам понравился курс? Поделитесь впечатлениями';

  @override
  String courseSubmitReviewCharCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String get courseSubmitReviewSubmit => 'Отправить отзыв';

  @override
  String get courseSubmitReviewSuccess => 'Отзыв отправлен';

  @override
  String get courseSubmitReviewError =>
      'Не удалось отправить отзыв. Попробуйте снова.';

  @override
  String get courseSubmitReviewSelectRating => 'Пожалуйста, выберите оценку';

  @override
  String get reviewTimeJustNow => 'Только что';

  @override
  String reviewTimeMinutesAgo(int count) {
    return '$count мин. назад';
  }

  @override
  String reviewTimeHoursAgo(int count) {
    return '$count ч. назад';
  }

  @override
  String reviewTimeDaysAgo(int count) {
    return '$count дн. назад';
  }

  @override
  String reviewTimeWeeksAgo(int count) {
    return '$count нед. назад';
  }

  @override
  String reviewTimeMonthsAgo(int count) {
    return '$count мес. назад';
  }

  @override
  String reviewTimeYearsAgo(int count) {
    return '$count г. назад';
  }
}
