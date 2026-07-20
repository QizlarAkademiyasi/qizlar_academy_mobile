// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Qizlar Academy';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubtitle => 'Enter your phone number';

  @override
  String get signInStart => 'Get started';

  @override
  String get orDivider => 'or';

  @override
  String get termsPrefix => 'By continuing you agree to the';

  @override
  String get termsLink => 'Terms of use';

  @override
  String get termsSuffix => '.';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get termsComingSoonMessage =>
      'The terms page will open in a later update.';

  @override
  String get signInPhoneTitle => 'Phone number';

  @override
  String get signInPhoneIncompleteMessage =>
      'Please enter your full phone number.';

  @override
  String get authPhoneOperatorRestrictedMessage =>
      'This number is not supported for SMS verification.';

  @override
  String get authOtpTooManyRequestsMessage =>
      'Too many attempts. Please wait a bit and try again.';

  @override
  String get connectionErrorMessage => 'Connection error. Please try again.';

  @override
  String get googleSignInErrorMessage =>
      'Google sign-in failed. Please try again.';

  @override
  String get telegramSignInInvalidLinkMessage =>
      'Could not open Telegram: invalid link from server.';

  @override
  String get telegramSignInLaunchFailedMessage =>
      'Could not open Telegram. Please try again.';

  @override
  String get telegramSignInOpenBotTitle => 'Telegram';

  @override
  String get telegramSignInEnterCodeHintMessage =>
      'Open the bot, then enter the code you receive here.';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInWithTelegram => 'Continue with Telegram';

  @override
  String get registerTitle => 'Personal details';

  @override
  String get registerSubtitle => 'Enter your personal information';

  @override
  String get firstNameHint => 'First name';

  @override
  String get lastNameHint => 'Last name';

  @override
  String get registerContinue => 'Continue';

  @override
  String get enterFirstName => 'Enter your first name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get saveProfileErrorMessage =>
      'Could not save your details. Please try again.';

  @override
  String get verificationTitle => 'Verification code';

  @override
  String verificationCodeSentTo(String phone) {
    return 'A verification code was sent to $phone.';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get resending => 'Sending…';

  @override
  String resendCodeCountdown(String time) {
    return 'Resend code: $time';
  }

  @override
  String get otpDigitsOnlyMessage => 'The code must contain only digits.';

  @override
  String get otpInvalidOrExpiredMessage =>
      'The code is incorrect or has expired.';

  @override
  String get otpSentAgain => 'Verification code was sent again.';

  @override
  String get verificationBackConfirmTitle => 'Go back?';

  @override
  String get verificationBackConfirmMessage =>
      'If you leave, you will need to request a new code to continue signing in.';

  @override
  String get verificationBackConfirmStay => 'Stay';

  @override
  String get verificationBackConfirmLeave => 'Go back';

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabCourses => 'Courses';

  @override
  String get mainTabLeaderboard => 'Leader';

  @override
  String get mainTabProfile => 'Profile';

  @override
  String get mainTabMore => 'More';

  @override
  String get mainMoreEmptyHint =>
      'Open “More” in the tab bar and choose a section.';

  @override
  String get guestSignInCta => 'Sign in';

  @override
  String get homeWelcomeGuestTitle => 'Welcome!';

  @override
  String get homeWelcomeGuestSubtitle => 'to Qizlar Academy';

  @override
  String get homeWelcomeBack => 'Welcome!';

  @override
  String get homeRegisteredUserFallback => 'Registered user';

  @override
  String get homePopularCourses => 'Popular courses';

  @override
  String get homeGuestCoursesGate => 'Sign up to view courses in full';

  @override
  String get homeGuestNotificationsGate => 'Sign up for notifications';

  @override
  String get homeLoadErrorMessage => 'Connection error. Please try again.';

  @override
  String get coursesCatalogLoadError =>
      'Couldn’t load courses. Please try again.';

  @override
  String get leaderboardLoadError =>
      'Couldn’t load the leaderboard. Please try again.';

  @override
  String get profileOverviewLoadError =>
      'Couldn’t load your profile. Please try again.';

  @override
  String get profilePreferenceUpdateError =>
      'Couldn’t update settings. Please try again.';

  @override
  String get notificationListLoadError =>
      'Couldn’t load notifications. Please try again.';

  @override
  String get notificationActionError =>
      'Couldn’t update notifications. Please try again.';

  @override
  String get courseDetailsLoadError =>
      'Couldn’t load course details. Please try again.';

  @override
  String get editProfileLoadError =>
      'Couldn’t load profile information. Please try again.';

  @override
  String get editProfileSaveError => 'Couldn’t save changes. Please try again.';

  @override
  String get coursesAllTitle => 'All courses';

  @override
  String get coursesSearchHint => 'Search courses…';

  @override
  String get coursesSearchScreenTitle => 'Search courses';

  @override
  String get coursesSearchIdleHint => 'Type a course name to search';

  @override
  String get coursesNoResults => 'No matching courses';

  @override
  String get coursesNotificationsComingSoonMessage =>
      'Notifications will be available soon.';

  @override
  String get coursesLastViewed => 'Last viewed';

  @override
  String get coursesInProgress => 'In progress';

  @override
  String get courseEnroll => 'Enroll in course';

  @override
  String get courseEnrollConfirmTitle => 'Enroll in this course?';

  @override
  String get courseEnrollConfirmBody =>
      'After enrolling you can open and watch all available lessons.';

  @override
  String get courseEnrollConfirmPrimary => 'Enroll';

  @override
  String get courseEnrollConfirmCancel => 'Not now';

  @override
  String get courseGuestFirstLessonCta => 'Watch first lesson';

  @override
  String get courseGuestMoreLessonsTitle => 'Sign in for more lessons';

  @override
  String get courseGuestMoreLessonsBody =>
      'You can watch the first lesson as a guest. Sign in to unlock the full course.';

  @override
  String get courseContinue => 'Continue';

  @override
  String courseTabLessons(int count) {
    return 'Lessons ($count)';
  }

  @override
  String get courseTabInfo => 'About';

  @override
  String courseTabReviews(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get lessonEmpty => 'No open lessons yet';

  @override
  String get lessonBackTooltip => 'Back';

  @override
  String lessonProgress(int current, int total) {
    return 'Lesson $current of $total';
  }

  @override
  String get lessonCompleted => 'Completed';

  @override
  String get lessonMarkComplete => 'Complete lesson';

  @override
  String get lessonVideoPlaybackError => 'Could not load the video.';

  @override
  String get lessonVideoPlaybackErrorYoutube =>
      'YouTube may temporarily block in-app playback. Open the video in your browser or the YouTube app.';

  @override
  String get lessonVideoOpenExternal => 'Open in browser';

  @override
  String get coursePillTabLessons => 'Lessons';

  @override
  String get coursePillTabInfo => 'About';

  @override
  String get coursePillTabReviews => 'Reviews';

  @override
  String get lessonQuizTestRowTitle => 'Test';

  @override
  String get lessonQuizGoToTest => 'Go to test';

  @override
  String get lessonQuizTitle => 'Test';

  @override
  String get lessonQuizQuestionLabel => 'Question';

  @override
  String lessonQuizQuestionProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String lessonQuizPercentComplete(int percent) {
    return '$percent% completed';
  }

  @override
  String get lessonQuizTypeSingle => 'Single choice';

  @override
  String get lessonQuizTypeMultiple => 'Multiple choice';

  @override
  String get lessonQuizMark => 'Mark answer';

  @override
  String get lessonQuizNext => 'Next';

  @override
  String get lessonQuizFinish => 'Finish';

  @override
  String get lessonQuizExitTitle => 'Leave the test?';

  @override
  String get lessonQuizExitBody =>
      'If you leave now, your results will not be saved.';

  @override
  String get lessonQuizExitStay => 'Stay';

  @override
  String get lessonQuizExitLeave => 'Leave';

  @override
  String get lessonQuizResultGreat => 'Great result!';

  @override
  String get lessonQuizResultPoor => 'Unsatisfactory result';

  @override
  String get lessonQuizStatCorrect => 'Correct';

  @override
  String get lessonQuizStatWrong => 'Wrong';

  @override
  String get lessonQuizStatTime => 'Time';

  @override
  String get lessonQuizContinue => 'Continue';

  @override
  String get lessonQuizRetry => 'Try again';

  @override
  String get lessonQuizErrorEmpty => 'This lesson has no test yet.';

  @override
  String get lessonQuizErrorLoad => 'Could not load the test.';

  @override
  String get lessonQuizErrorCheck => 'Could not verify the answer.';

  @override
  String get lessonQuizErrorSubmit => 'Could not submit the test.';

  @override
  String get lessonQuizErrorGeneric => 'Something went wrong.';

  @override
  String get lessonQuizAlreadyTaken =>
      'You have already completed this test. Retakes are not allowed.';

  @override
  String get courseModuleLockedMessage =>
      'Finish all lessons and tests in the previous module to continue.';

  @override
  String get courseLessonSequentialLockedMessage =>
      'Complete the previous lesson and its test (if any) before continuing.';

  @override
  String get courseCompleteCongratsTitle => 'Congratulations!';

  @override
  String get courseCompleteCongratsDescription =>
      'You have completed this course. Claim your certificate in the certificates section.';

  @override
  String get courseCompleteGetCertificate => 'Get certificate';

  @override
  String get courseCompleteClose => 'Close';

  @override
  String get leaderboardTitle => 'Top learners';

  @override
  String get leaderboardSubtitle => 'Ranking of the best students';

  @override
  String get leaderboardTabOverall => 'Overall';

  @override
  String get leaderboardTabWeekly => 'Weekly';

  @override
  String get leaderboardTabMonthly => 'Monthly';

  @override
  String get leaderboardSelectCourse => 'Choose a course';

  @override
  String get leaderboardFullRanking => 'Full ranking';

  @override
  String get leaderboardNoCourses => 'No courses yet';

  @override
  String get refresh => 'Refresh';

  @override
  String get leaderboardNoRatingYet => 'No ranking for this course yet';

  @override
  String get promotionTitle => 'Join in!';

  @override
  String get promotionSubtitle => 'Finish courses and earn points';

  @override
  String get promotionStart => 'Start';

  @override
  String get profileStatCourses => 'Courses';

  @override
  String get profileStatCertificates => 'Certificates';

  @override
  String get profileStatRating => 'Rating';

  @override
  String get profileStatPoints => 'Points';

  @override
  String get profileMenuCertificates => 'My certificates';

  @override
  String get profileMenuMyCourses => 'My courses';

  @override
  String get profileMenuMyActivity => 'My activity';

  @override
  String dailyCoinStreakTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days streak',
      one: '$count day streak',
    );
    return '$_temp0';
  }

  @override
  String get dailyCoinStreakSubtitle => 'You are on the right track';

  @override
  String dailyCoinRewardToday(int coins) {
    return '+$coins coins today';
  }

  @override
  String get dailyCoinClaimButton => 'Claim';

  @override
  String get dailyCoinClaimedButton => 'Claimed';

  @override
  String get dailyCoinLoadError => 'Could not load streak. Try again.';

  @override
  String get dailyCoinClaimError => 'Could not claim reward. Try again later.';

  @override
  String get activityScreenTitle => 'Activity';

  @override
  String get activityTabWeekly => 'Weekly';

  @override
  String get activityTabMonthly => 'Monthly';

  @override
  String get activitySectionStats => 'Statistics';

  @override
  String get activityStatTotalTime => 'Your total time in the app';

  @override
  String get activityStatAverageTime => 'Your average time';

  @override
  String get activityStatDailyRecord => 'Your daily record';

  @override
  String get activityStatCoursesCompleted => 'Total courses completed';

  @override
  String get activityLoadError => 'Could not load activity. Try again.';

  @override
  String activityDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String activityDurationHours(int hours) {
    return '$hours h';
  }

  @override
  String activityDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String activityCompletedCourses(int count) {
    return '$count courses';
  }

  @override
  String get profileMenuVacancies => 'Vacancies';

  @override
  String get vacanciesTitle => 'Vacancies';

  @override
  String get vacancyDetailCta => 'Details';

  @override
  String get vacancySalaryNegotiable => 'Salary negotiable';

  @override
  String vacancySalaryRange(String from, String to, String currency) {
    return '$from – $to $currency';
  }

  @override
  String get vacancyPostedMomentsAgo => 'Just now';

  @override
  String vacancyPostedMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String vacancyPostedHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String get vacancyPostedYesterday => 'Yesterday';

  @override
  String vacancyPostedDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get vacancyEmploymentIntern => 'Internship';

  @override
  String get vacancyEmploymentPartTime => 'Part-time';

  @override
  String get vacancyEmploymentFullTime => 'Full-time';

  @override
  String get vacancyEmploymentRemote => 'Remote';

  @override
  String get vacancyEmploymentOnsite => 'On-site';

  @override
  String get vacancyEmploymentContract => 'Contract';

  @override
  String get vacanciesEmptyTitle => 'No vacancies yet';

  @override
  String get vacanciesEmptySubtitle => 'Please check back later';

  @override
  String get vacanciesLoadError => 'Could not load vacancies';

  @override
  String get vacanciesLoadMoreError => 'Could not load more';

  @override
  String get vacancyDetailsTitle => 'Vacancy';

  @override
  String get vacancySheetEmploymentType => 'Employment type';

  @override
  String get vacancySheetSalary => 'Salary';

  @override
  String get vacancySheetLocation => 'Location';

  @override
  String get vacancySheetCategory => 'Category';

  @override
  String get vacancySheetPosted => 'Posted';

  @override
  String get vacancyDetailAbout => 'About the vacancy';

  @override
  String get vacancyDetailSkills => 'Skills';

  @override
  String get vacancyDetailRequirements => 'Requirements';

  @override
  String get vacancyApplyCta => 'Apply';

  @override
  String get vacancySalaryPerMonth => '/ month';

  @override
  String get vacancyDetailLoadError => 'Could not load vacancy';

  @override
  String get vacancyApplyPlaceholder =>
      'Coming soon — application will be available here';

  @override
  String get profileMenuProfileInfo => 'Profile information';

  @override
  String get profileMenuLanguage => 'Language';

  @override
  String get profileMenuShareApp => 'Share the app';

  @override
  String get profileShareAppSubtitle => 'Invite friends and family';

  @override
  String profileShareAppMessage(String link) {
    return 'Qizlar Academy brings free courses, a vibrant community, and room to grow for women and girls — all in one app.\n\nDownload and learn together:\n$link';
  }

  @override
  String get profileMenuAbout => 'About us';

  @override
  String get profileMenuHelp => 'Help center';

  @override
  String get profileMenuPrivacy => 'Privacy policy';

  @override
  String get profileSectionAccount => 'ACCOUNT';

  @override
  String profileCertificatesCountSubtitle(int count) {
    return '$count certificates';
  }

  @override
  String profileActiveCoursesCountSubtitle(int count) {
    return '$count active courses';
  }

  @override
  String get profileSectionSettings => 'SETTINGS';

  @override
  String get profileSectionGeneral => 'GENERAL';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Push messages';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get profileDarkModeSubtitle => 'Dark interface';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutConfirmTitle => 'Do you want to leave the app?';

  @override
  String get profileLogoutConfirmBody =>
      'We\'ll be waiting for you in new lessons.\nDo you want to log out now?';

  @override
  String get profileLogoutStay => 'Stay';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileDataMissing => 'Profile data is not available.';

  @override
  String get profileInformationTitle => 'Edit';

  @override
  String get profileInformationSave => 'Save';

  @override
  String get profileInformationSaveSuccess => 'Profile updated';

  @override
  String get profileInformationNameRequired => 'Enter your first and last name';

  @override
  String get profileInformationNoChanges => 'No changes to save';

  @override
  String get profileInformationPhotoUploadFailed =>
      'Could not upload the photo. Try again.';

  @override
  String get profileInformationPhotoPermissionDenied =>
      'Photo access is off. You can enable it in Settings.';

  @override
  String get profileInformationPhotoPickFailed =>
      'Could not select the photo. Try again.';

  @override
  String get profileInformationStatusTitle => 'Profile status';

  @override
  String get profileInformationPhoneLabel => 'Phone number';

  @override
  String get profileInformationPhoneNationalHint => 'XX XXX XX XX';

  @override
  String get editProfileUnsavedTitle => 'Unsaved changes';

  @override
  String get editProfileUnsavedMessage =>
      'You have unsaved changes to your profile. Save before leaving?';

  @override
  String get editProfileUnsavedSave => 'Save';

  @override
  String get editProfileUnsavedDiscard => 'Discard and leave';

  @override
  String get editProfileUnsavedContinue => 'Keep editing';

  @override
  String get aboutBrandTitle => 'QIZLAR AKADEMIYASI';

  @override
  String get aboutSectionProjectTitle => 'About the Qizlar Academy project';

  @override
  String get aboutProjectLead => 'Qizlar Academy';

  @override
  String get aboutProjectBody =>
      ' – is an interactive platform offering free learning courses for women and girls of all ages. It covers health, modern professions, crafts, education, entrepreneurship, psychology, and law. Sign up and grow your knowledge and skills across many fields through the platform.';

  @override
  String get aboutSectionSupportersTitle => 'Supporting us';

  @override
  String get aboutSupporterSadullaName => 'Alisher Sadullayev';

  @override
  String get aboutSupporterSadullaRole =>
      'Director of the Youth Affairs Agency of the Republic of Uzbekistan';

  @override
  String get aboutSupporterKattaxonName => 'Dilnoza Kattaxonova';

  @override
  String get aboutSupporterKattaxonRole =>
      'First deputy director of the Youth Affairs Agency. Doctor of Philosophy in political science';

  @override
  String get aboutSectionSocialTitle => 'Social networks';

  @override
  String get aboutSocialInstagramTitle => 'Instagram';

  @override
  String get aboutSocialInstagramSubtitle =>
      'Official Qizlar Academy Instagram channel';

  @override
  String get aboutSocialTelegramTitle => 'Telegram';

  @override
  String get aboutSocialTelegramSubtitle =>
      'Official Qizlar Academy Telegram channel';

  @override
  String get aboutSocialYoutubeTitle => 'YouTube';

  @override
  String get aboutSocialYoutubeSubtitle =>
      'Official Qizlar Academy YouTube channel';

  @override
  String get aboutUsLoadError => 'Could not load content. Try again.';

  @override
  String get aboutUsLinkOpenError => 'Could not open the link.';

  @override
  String get guestGateNotificationSettings =>
      'Sign up to manage notification settings';

  @override
  String get guestGateSaveSettings => 'Sign up to save settings';

  @override
  String get guestGateProfileFeatures => 'Sign up to use profile features';

  @override
  String get profileAppLanguageTitle => 'App language';

  @override
  String get profileBadgePickerTitle => 'Your badges';

  @override
  String get profileTezKundaTitle => 'Coming soon';

  @override
  String get profileTezKundaMessage =>
      'This section is not available yet. We\'re working on it — check back soon.';

  @override
  String get languageUzbek => 'Uzbek';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle => 'New messages will appear here.';

  @override
  String get notificationTabPlatform => 'Platform';

  @override
  String get notificationTabCommunity => 'Community';

  @override
  String get notificationDetailsMore => 'Details';

  @override
  String get notificationsEmptyThisTab => 'No notifications in this tab';

  @override
  String get notificationsEmptyThisTabSubtitle =>
      'Switch tabs or check back later.';

  @override
  String get guestGateMarkAllRead => 'Sign up to mark all as read';

  @override
  String get guestGateManageNotifications => 'Sign up to manage notifications';

  @override
  String get guestModeTitle => 'Guest mode';

  @override
  String get guestModeDescription =>
      'Create an account or sign in to use every feature.';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get retry => 'Try again';

  @override
  String get homeGuestCardSignIn => 'Sign in';

  @override
  String get myCoursesTitle => 'My courses';

  @override
  String myCoursesRatingReviewsLine(String rating, String reviewsCount) {
    return '$rating ($reviewsCount reviews)';
  }

  @override
  String myCoursesDurationHours(int hours) {
    return '$hours h';
  }

  @override
  String courseDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String courseDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get myCoursesEmptyTitle => 'No courses yet';

  @override
  String get myCoursesEmptySubtitle =>
      'Enroll in a course and it will show up here.';

  @override
  String get myCoursesLoadError => 'Could not load your courses. Try again.';

  @override
  String get myCoursesLoadMoreError =>
      'Could not load more. Scroll to try again.';

  @override
  String get certificatesBadgeGold => 'Gold certificate';

  @override
  String get certificatesBadgeSilver => 'Silver certificate';

  @override
  String get certificatesBadgeBronze => 'Bronze certificate';

  @override
  String get linkPromptYes => 'Yes';

  @override
  String get linkPromptNo => 'No';

  @override
  String get communityTelegramInviteTitle => 'Join our community';

  @override
  String get communityTelegramInviteDescription =>
      'You can find answers to your questions on our Telegram channel. Open our Telegram channel?';

  @override
  String get certificatesView => 'View';

  @override
  String certificatesSheetHeading(String courseName) {
    return '$courseName certificate';
  }

  @override
  String get certificatesSheetDescription =>
      'You have successfully completed the course and earned a certificate. May your knowledge always stay with you!';

  @override
  String get certificatesSheetDownload => 'Download';

  @override
  String get certificatesEmptyTitle => 'No certificates yet';

  @override
  String get certificatesEmptySubtitle =>
      'When you finish a course, your certificate will appear here.';

  @override
  String get certificatesLoadError => 'Could not load certificates. Try again.';

  @override
  String get certificateClaimError =>
      'Could not get your certificate. Try again later.';

  @override
  String get certificatesFileActionError =>
      'Could not download or share the file.';

  @override
  String get certificatesInstagramStoryNotConfigured =>
      'Instagram Story needs a Facebook App ID. Add FACEBOOK_APP_ID when building the app.';

  @override
  String get certificatesInstagramShareFailed =>
      'Could not open Instagram. Check that Instagram is installed and try again.';

  @override
  String courseReviewsSummaryCount(int count) {
    return '$count reviews';
  }

  @override
  String get courseReviewsEmptyTitle => 'No reviews yet';

  @override
  String get courseReviewsEmptySubtitle =>
      'When learners leave feedback, it will show up here.';

  @override
  String get courseLeaveReviewCta => 'Leave a review';

  @override
  String get courseSubmitReviewTitle => 'Leave a review';

  @override
  String get courseSubmitReviewRateTitle => 'Rate this course';

  @override
  String get courseSubmitReviewRateSubtitle =>
      'What do you think about what you learned and the lesson quality? Share your thoughts.';

  @override
  String get courseSubmitReviewYourCommentLabel => 'Your review';

  @override
  String get courseSubmitReviewCommentHint =>
      'Did you enjoy the course? Share your impressions';

  @override
  String courseSubmitReviewCharCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String get courseSubmitReviewSubmit => 'Submit review';

  @override
  String get courseSubmitReviewSuccess => 'Your review was sent';

  @override
  String get courseSubmitReviewError =>
      'Could not submit the review. Please try again.';

  @override
  String get courseSubmitReviewSelectRating => 'Please select a rating';

  @override
  String get reviewTimeJustNow => 'Just now';

  @override
  String reviewTimeMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String reviewTimeHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String reviewTimeDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String reviewTimeWeeksAgo(int count) {
    return '$count wk ago';
  }

  @override
  String reviewTimeMonthsAgo(int count) {
    return '$count mo ago';
  }

  @override
  String reviewTimeYearsAgo(int count) {
    return '$count y ago';
  }

  @override
  String get personalInfoGateSubmitError => 'Could not save. Please try again.';

  @override
  String get personalInfoGateContinue => 'Continue';

  @override
  String get personalInfoGateAddressTitle => 'Address';

  @override
  String get personalInfoGateAddressSubtitle =>
      'Select your region, district, and neighborhood.';

  @override
  String get personalInfoGateCountry => 'Country';

  @override
  String get personalInfoGateRegion => 'Region';

  @override
  String get personalInfoGateDistrict => 'District';

  @override
  String get personalInfoGateNeighborhood => 'Neighborhood';

  @override
  String get personalInfoGatePersonalInfoTitle => 'Personal information';

  @override
  String get personalInfoGatePersonalInfoSubtitle =>
      'Enter your date of birth.';

  @override
  String get personalInfoGateBirthday => 'Date of birth';

  @override
  String get personalInfoGateEducationTitle => 'Education';

  @override
  String get personalInfoGateEducationSubtitle => 'Select your education type.';

  @override
  String get courseDetailsShareTooltip => 'Share course';

  @override
  String courseDetailsShareMessage(String title, String url) {
    return 'Check out \"$title\": $url';
  }

  @override
  String get certificatesSheetInstagramStory => 'Instagram Story';

  @override
  String get profileDeleteAccountTile => 'Delete account';

  @override
  String get profileDeleteAccountTitle => 'Delete account?';

  @override
  String profileDeleteAccountConfirmBody(String webUrl) {
    return 'This will permanently delete your account. You can also request deletion on the web: $webUrl';
  }

  @override
  String get profileDeleteAccountCancel => 'Cancel';

  @override
  String get profileDeleteAccountContinue => 'Continue';

  @override
  String get profileDeleteAccountFinalTitle => 'Are you sure?';

  @override
  String get profileDeleteAccountFinalBody =>
      'This cannot be undone. Your data will be removed.';

  @override
  String get profileDeleteAccountConfirmAction => 'Delete';

  @override
  String get profileDeleteAccountProgress => 'Deleting account…';

  @override
  String get profileDeleteAccountError =>
      'Could not delete account. Try again.';

  @override
  String get appUpdateAvailableTitle => 'Update available';

  @override
  String get appUpdateAvailableBody =>
      'A new version of the app is available. Update for the best experience.';

  @override
  String get appUpdateLater => 'Later';

  @override
  String get appUpdateCta => 'Update';

  @override
  String get profileNotificationsEnableFailed =>
      'Could not update notification settings. Try again.';

  @override
  String get profileInformationPersonalTitle => 'Phone number';

  @override
  String get profileInformationOccupation => 'Occupation';

  @override
  String get profileInformationBirthday => 'Date of birth';

  @override
  String get profileInformationAddressTitle => 'Address';

  @override
  String get profileInformationRegion => 'Region';

  @override
  String get profileInformationDistrict => 'District';

  @override
  String get profileInformationNeighborhood => 'Neighborhood';

  @override
  String get storeTitle => 'Market';

  @override
  String get storeProduct => 'Product';

  @override
  String get storeAllCategories => 'All';

  @override
  String get storeNoProducts => 'No products yet';

  @override
  String get storeLoadError => 'Failed to load products';

  @override
  String get storeLoadMoreError => 'Error loading more';

  @override
  String get storeDetailTitle => 'Product';

  @override
  String get storeAboutProduct => 'About product';

  @override
  String storeInStock(Object count) {
    return '$count in stock';
  }

  @override
  String get storeSoldOut => 'Sold out';

  @override
  String get storeBuyButton => 'Buy now';

  @override
  String get storeReturnButton => 'Return';

  @override
  String get storeViewButton => 'View';

  @override
  String get storeAllTypes => 'All types';

  @override
  String get storeSize => 'Size';

  @override
  String get storeOrderSuccess => 'Order placed successfully!';

  @override
  String get storeOrderError => 'Failed to place order';

  @override
  String get storePromoExpired => 'Promo code expired';

  @override
  String get storeInsufficientStock => 'Product out of stock';

  @override
  String get storeCopied => 'Copied';

  @override
  String get storeHistoryTitle => 'Order history';

  @override
  String get storeHistoryEmpty => 'No orders yet';

  @override
  String get storeHistoryLoadError => 'Failed to load orders';

  @override
  String get storeStatusPending => 'Pending';

  @override
  String get storeStatusPaid => 'Paid';

  @override
  String get storeStatusShipped => 'Shipped';

  @override
  String get storeStatusDelivered => 'Delivered';

  @override
  String get storeStatusCancelled => 'Cancelled';

  @override
  String get storeStatusRefunded => 'Refunded';

  @override
  String get storeExtraMenuTitle => 'More';

  @override
  String get offlineTitle => 'No internet connection';

  @override
  String get offlineDescription =>
      'Check your internet connection. The app will continue automatically when you are back online.';

  @override
  String get offlineRetry => 'Check again';

  @override
  String get offlineWaiting => 'Waiting for an internet connection...';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksBalanceLabel => 'BALANCE';

  @override
  String get tasksCoinLabel => 'Coins';

  @override
  String tasksStreakTitle(int count) {
    return '$count-Day Streak';
  }

  @override
  String get tasksStreakSubtitle => 'Keep it going!';

  @override
  String get tasksTodayTitle => 'Today\'s tasks';

  @override
  String get tasksOtherTitle => 'Other tasks';

  @override
  String get tasksEmptyTitle => 'No tasks yet';

  @override
  String get tasksEmptySubtitle => 'New tasks will appear here';

  @override
  String get tasksLoadError => 'Could not load tasks. Try again.';

  @override
  String get tasksActionUnavailable => 'This task action is not available yet';
}
