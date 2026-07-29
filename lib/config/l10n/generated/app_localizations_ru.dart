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
  String get telegramSignInInvalidLinkMessage =>
      'Не удалось открыть Telegram: неверная ссылка от сервера.';

  @override
  String get telegramSignInLaunchFailedMessage =>
      'Не удалось открыть Telegram. Попробуйте снова.';

  @override
  String get telegramSignInOpenBotTitle => 'Telegram';

  @override
  String get telegramSignInEnterCodeHintMessage =>
      'Откройте бота и введите полученный код здесь.';

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
  String get verificationBackConfirmTitle => 'Вернуться назад?';

  @override
  String get verificationBackConfirmMessage =>
      'Если вы выйдете, нужно будет снова запросить код для входа.';

  @override
  String get verificationBackConfirmStay => 'Остаться';

  @override
  String get verificationBackConfirmLeave => 'Назад';

  @override
  String get mainTabHome => 'Главная';

  @override
  String get mainTabCourses => 'Курсы';

  @override
  String get mainTabLeaderboard => 'Лидеры';

  @override
  String get mainTabProfile => 'Профиль';

  @override
  String get mainTabMore => 'Ещё';

  @override
  String get mainMoreEmptyHint =>
      'Нажмите «Ещё» на панели вкладок и выберите раздел.';

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
  String get coursesCatalogLoadError =>
      'Не удалось загрузить курсы. Попробуйте ещё раз.';

  @override
  String get leaderboardLoadError =>
      'Не удалось загрузить рейтинг. Попробуйте ещё раз.';

  @override
  String get profileOverviewLoadError =>
      'Не удалось загрузить профиль. Попробуйте ещё раз.';

  @override
  String get profilePreferenceUpdateError =>
      'Не удалось обновить настройки. Попробуйте ещё раз.';

  @override
  String get notificationListLoadError =>
      'Не удалось загрузить уведомления. Попробуйте ещё раз.';

  @override
  String get notificationActionError =>
      'Не удалось обновить уведомления. Попробуйте ещё раз.';

  @override
  String get courseDetailsLoadError =>
      'Не удалось загрузить данные курса. Попробуйте ещё раз.';

  @override
  String get editProfileLoadError =>
      'Не удалось загрузить данные профиля. Попробуйте ещё раз.';

  @override
  String get editProfileSaveError =>
      'Не удалось сохранить изменения. Попробуйте ещё раз.';

  @override
  String get coursesAllTitle => 'Все курсы';

  @override
  String get coursesSearchHint => 'Поиск курсов…';

  @override
  String get coursesSearchScreenTitle => 'Поиск курсов';

  @override
  String get coursesSearchIdleHint => 'Введите название курса для поиска';

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
  String get lessonVideoPlaybackError => 'Не удалось загрузить видео.';

  @override
  String get lessonVideoPlaybackErrorYoutube =>
      'YouTube может временно ограничить воспроизведение в приложении. Откройте видео в браузере или в приложении YouTube.';

  @override
  String get lessonVideoOpenExternal => 'Открыть в браузере';

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
  String get lessonQuizRetry => 'Попробовать снова';

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
  String get courseModuleLockedMessage =>
      'Чтобы перейти к следующему модулю, завершите все уроки и тесты в предыдущем.';

  @override
  String get courseLessonSequentialLockedMessage =>
      'Чтобы перейти к следующему уроку, завершите предыдущий урок и тест (если есть).';

  @override
  String get courseCompleteCongratsTitle => 'Поздравляем!';

  @override
  String get courseCompleteCongratsDescription =>
      'Вы завершили курс. Получите сертификат в разделе «Мои сертификаты».';

  @override
  String get courseCompleteGetCertificate => 'Получить сертификат';

  @override
  String get courseCompleteClose => 'Закрыть';

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
  String dailyCoinStreakTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней подряд',
      many: '$count дней подряд',
      few: '$count дня подряд',
      one: '$count день подряд',
    );
    return '$_temp0';
  }

  @override
  String get dailyCoinStreakSubtitle => 'Вы на верном пути';

  @override
  String get dailyCoinDayToday => 'Сегодня';

  @override
  String get dailyCoinDayTomorrow => 'Завтра';

  @override
  String dailyCoinDayNumber(int day) {
    String _temp0 = intl.Intl.pluralLogic(
      day,
      locale: localeName,
      other: '$day дня',
      many: '$day дней',
      few: '$day дня',
      one: '$day день',
    );
    return '$_temp0';
  }

  @override
  String dailyCoinRewardToday(int coins) {
    return '+$coins монет сегодня';
  }

  @override
  String get dailyCoinClaimButton => 'Получить';

  @override
  String get dailyCoinClaimedButton => 'Получено';

  @override
  String get dailyCoinLoadError =>
      'Не удалось загрузить данные. Попробуйте ещё раз.';

  @override
  String get dailyCoinClaimError =>
      'Не удалось получить награду. Попробуйте позже.';

  @override
  String get activityScreenTitle => 'Активность';

  @override
  String get activityTabWeekly => 'Неделя';

  @override
  String get activityTabMonthly => 'Месяц';

  @override
  String get activitySectionStats => 'Статистика';

  @override
  String get activityStatTotalTime => 'Общее время в приложении';

  @override
  String get activityStatAverageTime => 'Ваше среднее время';

  @override
  String get activityStatDailyRecord => 'Ваш дневной рекорд';

  @override
  String get activityStatCoursesCompleted => 'Всего завершено курсов';

  @override
  String get activityLoadError =>
      'Не удалось загрузить активность. Попробуйте ещё раз.';

  @override
  String activityDurationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String activityDurationHours(int hours) {
    return '$hours ч';
  }

  @override
  String activityDurationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String activityCompletedCourses(int count) {
    return '$count шт.';
  }

  @override
  String get profileMenuVacancies => 'Вакансии';

  @override
  String get vacanciesTitle => 'Вакансии';

  @override
  String get vacancyDetailCta => 'Подробнее';

  @override
  String get vacancySalaryNegotiable => 'По договорённости';

  @override
  String vacancySalaryRange(String from, String to, String currency) {
    return '$from – $to $currency';
  }

  @override
  String get vacancyPostedMomentsAgo => 'Только что';

  @override
  String vacancyPostedMinutesAgo(int count) {
    return '$count мин. назад';
  }

  @override
  String vacancyPostedHoursAgo(int count) {
    return '$count ч. назад';
  }

  @override
  String get vacancyPostedYesterday => 'Вчера';

  @override
  String vacancyPostedDaysAgo(int count) {
    return '$count дн. назад';
  }

  @override
  String get vacancyEmploymentIntern => 'Стажировка';

  @override
  String get vacancyEmploymentPartTime => 'Частичная занятость';

  @override
  String get vacancyEmploymentFullTime => 'Полная занятость';

  @override
  String get vacancyEmploymentRemote => 'Удалённо';

  @override
  String get vacancyEmploymentOnsite => 'В офисе';

  @override
  String get vacancyEmploymentContract => 'Контракт';

  @override
  String get vacanciesEmptyTitle => 'Пока нет вакансий';

  @override
  String get vacanciesEmptySubtitle => 'Загляните позже';

  @override
  String get vacanciesLoadError => 'Не удалось загрузить вакансии';

  @override
  String get vacanciesLoadMoreError => 'Не удалось подгрузить список';

  @override
  String get vacancyDetailsTitle => 'Вакансия';

  @override
  String get vacancySheetEmploymentType => 'Тип занятости';

  @override
  String get vacancySheetSalary => 'Зарплата';

  @override
  String get vacancySheetLocation => 'Локация';

  @override
  String get vacancySheetCategory => 'Направление';

  @override
  String get vacancySheetPosted => 'Опубликовано';

  @override
  String get vacancyDetailAbout => 'О вакансии';

  @override
  String get vacancyDetailSkills => 'Навыки';

  @override
  String get vacancyDetailRequirements => 'Обязанности';

  @override
  String get vacancyApplyCta => 'Откликнуться';

  @override
  String get vacancySalaryPerMonth => '/ в месяц';

  @override
  String get vacancyDetailLoadError => 'Не удалось загрузить вакансию';

  @override
  String get vacancyApplyPlaceholder =>
      'Скоро — здесь появится возможность отклика';

  @override
  String get profileMenuProfileInfo => 'Данные профиля';

  @override
  String get profileMenuLanguage => 'Язык';

  @override
  String get profileMenuShareApp => 'Поделиться приложением';

  @override
  String get profileShareAppSubtitle => 'Поделитесь с близкими';

  @override
  String profileShareAppMessage(String link) {
    return 'Qizlar Akademiyasi — бесплатные курсы, активное сообщество и возможности для роста для женщин и девушек в одном приложении.\n\nСкачайте и учитесь вместе:\n$link';
  }

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
  String get editProfileUnsavedTitle => 'Несохранённые изменения';

  @override
  String get editProfileUnsavedMessage =>
      'В профиле есть несохранённые изменения. Сохранить перед выходом?';

  @override
  String get editProfileUnsavedSave => 'Сохранить';

  @override
  String get editProfileUnsavedDiscard => 'Выйти без сохранения';

  @override
  String get editProfileUnsavedContinue => 'Продолжить редактирование';

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
  String get profileBadgePickerTitle => 'Ваши значки';

  @override
  String get profileTezKundaTitle => 'Скоро';

  @override
  String get profileTezKundaMessage =>
      'Этот раздел пока недоступен. Мы над ним работаем — загляните позже.';

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
  String get notificationTabPlatform => 'Платформа';

  @override
  String get notificationTabCommunity => 'Сообщество';

  @override
  String get notificationDetailsMore => 'Подробнее';

  @override
  String get notificationsEmptyThisTab => 'В этой вкладке нет уведомлений';

  @override
  String get notificationsEmptyThisTabSubtitle =>
      'Переключите вкладку или загляните позже.';

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
  String courseDurationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String courseDurationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
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
  String get linkPromptYes => 'Да';

  @override
  String get linkPromptNo => 'Нет';

  @override
  String get communityTelegramInviteTitle => 'Присоединяйтесь к сообществу';

  @override
  String get communityTelegramInviteDescription =>
      'На нашем канале в Telegram вы найдёте ответы на вопросы. Перейти в канал?';

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
  String get certificateClaimError =>
      'Не удалось получить сертификат. Попробуйте позже.';

  @override
  String get certificatesFileActionError =>
      'Не удалось скачать или поделиться файлом.';

  @override
  String get certificatesInstagramStoryNotConfigured =>
      'Для истории в Instagram нужен Facebook App ID. Укажите FACEBOOK_APP_ID при сборке приложения.';

  @override
  String get certificatesInstagramShareFailed =>
      'Не удалось открыть Instagram. Убедитесь, что приложение установлено, и попробуйте снова.';

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

  @override
  String get personalInfoGateSubmitError =>
      'Не удалось сохранить. Попробуйте снова.';

  @override
  String get personalInfoGateContinue => 'Продолжить';

  @override
  String get personalInfoGateAddressTitle => 'Адрес';

  @override
  String get personalInfoGateAddressSubtitle =>
      'Выберите область, район и махаллю.';

  @override
  String get personalInfoGateCountry => 'Страна';

  @override
  String get personalInfoGateRegion => 'Область';

  @override
  String get personalInfoGateDistrict => 'Район';

  @override
  String get personalInfoGateNeighborhood => 'Махалля';

  @override
  String get personalInfoGatePersonalInfoTitle => 'Личные данные';

  @override
  String get personalInfoGatePersonalInfoSubtitle => 'Укажите дату рождения.';

  @override
  String get personalInfoGateBirthday => 'Дата рождения';

  @override
  String get personalInfoGateEducationTitle => 'Образование';

  @override
  String get personalInfoGateEducationSubtitle => 'Выберите тип образования.';

  @override
  String get courseDetailsShareTooltip => 'Поделиться курсом';

  @override
  String courseDetailsShareMessage(String title, String url) {
    return 'Курс «$title»: $url';
  }

  @override
  String get portfolioShareTooltip => 'Поделиться публикацией портфолио';

  @override
  String get portfolioShareSubject => 'Qizlar Akademiyasi — Портфолио';

  @override
  String portfolioShareMessage(String caption, String url) {
    return '«$caption»\n\nПосмотрите проект портфолио в Qizlar Akademiyasi:\n$url';
  }

  @override
  String portfolioShareMessageWithoutCaption(String url) {
    return 'Посмотрите проект портфолио в Qizlar Akademiyasi:\n$url';
  }

  @override
  String get portfolioShareError =>
      'Не удалось поделиться публикацией. Попробуйте снова.';

  @override
  String get certificatesSheetInstagramStory => 'История Instagram';

  @override
  String get profileDeleteAccountTile => 'Удалить аккаунт';

  @override
  String get profileDeleteAccountTitle => 'Удалить аккаунт?';

  @override
  String profileDeleteAccountConfirmBody(String webUrl) {
    return 'Аккаунт будет удалён безвозвратно. Запрос можно также отправить на сайте: $webUrl';
  }

  @override
  String get profileDeleteAccountCancel => 'Отмена';

  @override
  String get profileDeleteAccountContinue => 'Продолжить';

  @override
  String get profileDeleteAccountFinalTitle => 'Вы уверены?';

  @override
  String get profileDeleteAccountFinalBody =>
      'Это действие нельзя отменить. Данные будут удалены.';

  @override
  String get profileDeleteAccountConfirmAction => 'Удалить';

  @override
  String get profileDeleteAccountProgress => 'Удаление аккаунта…';

  @override
  String get profileDeleteAccountError =>
      'Не удалось удалить аккаунт. Попробуйте снова.';

  @override
  String get appUpdateAvailableTitle => 'Доступно обновление';

  @override
  String get appUpdateAvailableBody =>
      'Вышла новая версия приложения. Обновитесь для лучшей работы.';

  @override
  String get appUpdateLater => 'Позже';

  @override
  String get appUpdateCta => 'Обновить';

  @override
  String get profileNotificationsEnableFailed =>
      'Не удалось изменить настройки уведомлений. Попробуйте снова.';

  @override
  String get profileInformationPersonalTitle => 'Номер телефона';

  @override
  String get profileInformationOccupation => 'Профессия';

  @override
  String get profileInformationBirthday => 'Дата рождения';

  @override
  String get profileInformationAddressTitle => 'Адрес';

  @override
  String get profileInformationRegion => 'Область';

  @override
  String get profileInformationDistrict => 'Район';

  @override
  String get profileInformationNeighborhood => 'Махалля';

  @override
  String get storeTitle => 'Маркет';

  @override
  String get storeProduct => 'Товар';

  @override
  String get storeAllCategories => 'Все';

  @override
  String get storeNoProducts => 'Пока нет товаров';

  @override
  String get storeLoadError => 'Ошибка загрузки товаров';

  @override
  String get storeLoadMoreError => 'Ошибка при загрузке';

  @override
  String get storeDetailTitle => 'Товар';

  @override
  String get storeAboutProduct => 'О товаре';

  @override
  String storeInStock(Object count) {
    return '$count на складе';
  }

  @override
  String get storeSoldOut => 'Распродано';

  @override
  String get storeBuyButton => 'Купить';

  @override
  String get storeReturnButton => 'Вернуть';

  @override
  String get storeViewButton => 'Посмотреть';

  @override
  String get storeAllTypes => 'Все типы';

  @override
  String get storeSize => 'Размер';

  @override
  String get storeOrderSuccess => 'Заказ успешно оформлен!';

  @override
  String get storeOrderError => 'Ошибка при оформлении заказа';

  @override
  String get storePromoExpired => 'Промокод недоступен';

  @override
  String get storeInsufficientStock => 'Товар распродан';

  @override
  String get storeCopied => 'Скопировано';

  @override
  String get storeHistoryTitle => 'История заказов';

  @override
  String get storeHistoryEmpty => 'Заказов пока нет';

  @override
  String get storeHistoryLoadError => 'Ошибка загрузки заказов';

  @override
  String get storeStatusPending => 'Ожидает';

  @override
  String get storeStatusPaid => 'Оплачен';

  @override
  String get storeStatusShipped => 'Отправлен';

  @override
  String get storeStatusDelivered => 'Доставлен';

  @override
  String get storeStatusCancelled => 'Отменён';

  @override
  String get storeStatusRefunded => 'Возврат';

  @override
  String get storeExtraMenuTitle => 'Ещё';

  @override
  String get offlineTitle => 'Нет подключения к интернету';

  @override
  String get offlineDescription =>
      'Проверьте подключение. Приложение продолжит работу автоматически после восстановления интернета.';

  @override
  String get offlineRetry => 'Проверить снова';

  @override
  String get offlineWaiting => 'Ожидание подключения к интернету...';

  @override
  String get tasksTitle => 'Задания';

  @override
  String get tasksBalanceLabel => 'БАЛАНС';

  @override
  String get tasksCoinLabel => 'Монет';

  @override
  String tasksStreakTitle(int count) {
    return 'Серия: $count дней';
  }

  @override
  String get tasksStreakSubtitle => 'Продолжайте!';

  @override
  String get tasksTodayTitle => 'Задания на сегодня';

  @override
  String get tasksOtherTitle => 'Другие задания';

  @override
  String get tasksEmptyTitle => 'Заданий пока нет';

  @override
  String get tasksEmptySubtitle => 'Новые задания появятся здесь';

  @override
  String get tasksLoadError =>
      'Не удалось загрузить задания. Попробуйте снова.';

  @override
  String get tasksActionUnavailable =>
      'Действие для этого задания пока недоступно';

  @override
  String get birthdayStoryLabel => 'День рождения';

  @override
  String get birthdayStoryCongratulations => 'Поздравляем!';

  @override
  String get birthdayStoryMessage =>
      'Команда «Qizlar Akademiyasi» от всей души поздравляет вас!';
}
