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
  String get telegramSignInComingSoonMessage =>
      'Telegram sign-in will be available in a later update.';

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
  String get mainTabHome => 'Home';

  @override
  String get mainTabCourses => 'Courses';

  @override
  String get mainTabLeaderboard => 'Leaderboard';

  @override
  String get mainTabProfile => 'Profile';

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
  String get coursesAllTitle => 'All courses';

  @override
  String get coursesSearchHint => 'Search courses…';

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
  String get profileMenuProfileInfo => 'Profile information';

  @override
  String get profileMenuLanguage => 'Language';

  @override
  String get profileMenuShareApp => 'Share the app';

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
  String get certificatesFileActionError =>
      'Could not download or share the file.';

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
}
