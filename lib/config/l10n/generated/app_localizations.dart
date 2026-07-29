import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Qizlar Academy'**
  String get appTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get signInSubtitle;

  /// No description provided for @signInStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get signInStart;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @termsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the'**
  String get termsPrefix;

  /// No description provided for @termsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsLink;

  /// No description provided for @termsSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get termsSuffix;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @termsComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'The terms page will open in a later update.'**
  String get termsComingSoonMessage;

  /// No description provided for @signInPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get signInPhoneTitle;

  /// No description provided for @signInPhoneIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full phone number.'**
  String get signInPhoneIncompleteMessage;

  /// No description provided for @authPhoneOperatorRestrictedMessage.
  ///
  /// In en, this message translates to:
  /// **'This number is not supported for SMS verification.'**
  String get authPhoneOperatorRestrictedMessage;

  /// No description provided for @authOtpTooManyRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a bit and try again.'**
  String get authOtpTooManyRequestsMessage;

  /// No description provided for @connectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get connectionErrorMessage;

  /// No description provided for @googleSignInErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInErrorMessage;

  /// No description provided for @telegramSignInInvalidLinkMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open Telegram: invalid link from server.'**
  String get telegramSignInInvalidLinkMessage;

  /// No description provided for @telegramSignInLaunchFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not open Telegram. Please try again.'**
  String get telegramSignInLaunchFailedMessage;

  /// No description provided for @telegramSignInOpenBotTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegramSignInOpenBotTitle;

  /// No description provided for @telegramSignInEnterCodeHintMessage.
  ///
  /// In en, this message translates to:
  /// **'Open the bot, then enter the code you receive here.'**
  String get telegramSignInEnterCodeHintMessage;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithTelegram.
  ///
  /// In en, this message translates to:
  /// **'Continue with Telegram'**
  String get signInWithTelegram;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your personal information'**
  String get registerSubtitle;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @registerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get registerContinue;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @saveProfileErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not save your details. Please try again.'**
  String get saveProfileErrorMessage;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationTitle;

  /// No description provided for @verificationCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A verification code was sent to {phone}.'**
  String verificationCodeSentTo(String phone);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get resending;

  /// No description provided for @resendCodeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend code: {time}'**
  String resendCodeCountdown(String time);

  /// No description provided for @otpDigitsOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'The code must contain only digits.'**
  String get otpDigitsOnlyMessage;

  /// No description provided for @otpInvalidOrExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect or has expired.'**
  String get otpInvalidOrExpiredMessage;

  /// No description provided for @otpSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Verification code was sent again.'**
  String get otpSentAgain;

  /// No description provided for @verificationBackConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Go back?'**
  String get verificationBackConfirmTitle;

  /// No description provided for @verificationBackConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'If you leave, you will need to request a new code to continue signing in.'**
  String get verificationBackConfirmMessage;

  /// No description provided for @verificationBackConfirmStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get verificationBackConfirmStay;

  /// No description provided for @verificationBackConfirmLeave.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get verificationBackConfirmLeave;

  /// No description provided for @mainTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainTabHome;

  /// No description provided for @mainTabCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get mainTabCourses;

  /// No description provided for @mainTabLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get mainTabLeaderboard;

  /// No description provided for @mainTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get mainTabProfile;

  /// No description provided for @mainTabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get mainTabMore;

  /// No description provided for @mainMoreEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Open “More” in the tab bar and choose a section.'**
  String get mainMoreEmptyHint;

  /// No description provided for @guestSignInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get guestSignInCta;

  /// No description provided for @homeWelcomeGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get homeWelcomeGuestTitle;

  /// No description provided for @homeWelcomeGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'to Qizlar Academy'**
  String get homeWelcomeGuestSubtitle;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get homeWelcomeBack;

  /// No description provided for @homeRegisteredUserFallback.
  ///
  /// In en, this message translates to:
  /// **'Registered user'**
  String get homeRegisteredUserFallback;

  /// No description provided for @homePopularCourses.
  ///
  /// In en, this message translates to:
  /// **'Popular courses'**
  String get homePopularCourses;

  /// No description provided for @homeGuestCoursesGate.
  ///
  /// In en, this message translates to:
  /// **'Sign up to view courses in full'**
  String get homeGuestCoursesGate;

  /// No description provided for @homeGuestNotificationsGate.
  ///
  /// In en, this message translates to:
  /// **'Sign up for notifications'**
  String get homeGuestNotificationsGate;

  /// No description provided for @homeLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get homeLoadErrorMessage;

  /// No description provided for @coursesCatalogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load courses. Please try again.'**
  String get coursesCatalogLoadError;

  /// No description provided for @leaderboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load the leaderboard. Please try again.'**
  String get leaderboardLoadError;

  /// No description provided for @profileOverviewLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load your profile. Please try again.'**
  String get profileOverviewLoadError;

  /// No description provided for @profilePreferenceUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t update settings. Please try again.'**
  String get profilePreferenceUpdateError;

  /// No description provided for @notificationListLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load notifications. Please try again.'**
  String get notificationListLoadError;

  /// No description provided for @notificationActionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t update notifications. Please try again.'**
  String get notificationActionError;

  /// No description provided for @courseDetailsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load course details. Please try again.'**
  String get courseDetailsLoadError;

  /// No description provided for @editProfileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load profile information. Please try again.'**
  String get editProfileLoadError;

  /// No description provided for @editProfileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save changes. Please try again.'**
  String get editProfileSaveError;

  /// No description provided for @coursesAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All courses'**
  String get coursesAllTitle;

  /// No description provided for @coursesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search courses…'**
  String get coursesSearchHint;

  /// No description provided for @coursesSearchScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Search courses'**
  String get coursesSearchScreenTitle;

  /// No description provided for @coursesSearchIdleHint.
  ///
  /// In en, this message translates to:
  /// **'Type a course name to search'**
  String get coursesSearchIdleHint;

  /// No description provided for @coursesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching courses'**
  String get coursesNoResults;

  /// No description provided for @coursesNotificationsComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be available soon.'**
  String get coursesNotificationsComingSoonMessage;

  /// No description provided for @coursesLastViewed.
  ///
  /// In en, this message translates to:
  /// **'Last viewed'**
  String get coursesLastViewed;

  /// No description provided for @coursesInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get coursesInProgress;

  /// No description provided for @courseEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll in course'**
  String get courseEnroll;

  /// No description provided for @courseEnrollConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Enroll in this course?'**
  String get courseEnrollConfirmTitle;

  /// No description provided for @courseEnrollConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'After enrolling you can open and watch all available lessons.'**
  String get courseEnrollConfirmBody;

  /// No description provided for @courseEnrollConfirmPrimary.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get courseEnrollConfirmPrimary;

  /// No description provided for @courseEnrollConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get courseEnrollConfirmCancel;

  /// No description provided for @courseGuestFirstLessonCta.
  ///
  /// In en, this message translates to:
  /// **'Watch first lesson'**
  String get courseGuestFirstLessonCta;

  /// No description provided for @courseGuestMoreLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in for more lessons'**
  String get courseGuestMoreLessonsTitle;

  /// No description provided for @courseGuestMoreLessonsBody.
  ///
  /// In en, this message translates to:
  /// **'You can watch the first lesson as a guest. Sign in to unlock the full course.'**
  String get courseGuestMoreLessonsBody;

  /// No description provided for @courseContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get courseContinue;

  /// No description provided for @courseTabLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons ({count})'**
  String courseTabLessons(int count);

  /// No description provided for @courseTabInfo.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get courseTabInfo;

  /// No description provided for @courseTabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews ({count})'**
  String courseTabReviews(int count);

  /// No description provided for @lessonEmpty.
  ///
  /// In en, this message translates to:
  /// **'No open lessons yet'**
  String get lessonEmpty;

  /// No description provided for @lessonBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get lessonBackTooltip;

  /// No description provided for @lessonProgress.
  ///
  /// In en, this message translates to:
  /// **'Lesson {current} of {total}'**
  String lessonProgress(int current, int total);

  /// No description provided for @lessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get lessonCompleted;

  /// No description provided for @lessonMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete lesson'**
  String get lessonMarkComplete;

  /// No description provided for @lessonVideoPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the video.'**
  String get lessonVideoPlaybackError;

  /// No description provided for @lessonVideoPlaybackErrorYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube may temporarily block in-app playback. Open the video in your browser or the YouTube app.'**
  String get lessonVideoPlaybackErrorYoutube;

  /// No description provided for @lessonVideoOpenExternal.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get lessonVideoOpenExternal;

  /// No description provided for @coursePillTabLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get coursePillTabLessons;

  /// No description provided for @coursePillTabInfo.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get coursePillTabInfo;

  /// No description provided for @coursePillTabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get coursePillTabReviews;

  /// No description provided for @lessonQuizTestRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get lessonQuizTestRowTitle;

  /// No description provided for @lessonQuizGoToTest.
  ///
  /// In en, this message translates to:
  /// **'Go to test'**
  String get lessonQuizGoToTest;

  /// No description provided for @lessonQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get lessonQuizTitle;

  /// No description provided for @lessonQuizQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get lessonQuizQuestionLabel;

  /// No description provided for @lessonQuizQuestionProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String lessonQuizQuestionProgress(int current, int total);

  /// No description provided for @lessonQuizPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed'**
  String lessonQuizPercentComplete(int percent);

  /// No description provided for @lessonQuizTypeSingle.
  ///
  /// In en, this message translates to:
  /// **'Single choice'**
  String get lessonQuizTypeSingle;

  /// No description provided for @lessonQuizTypeMultiple.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get lessonQuizTypeMultiple;

  /// No description provided for @lessonQuizMark.
  ///
  /// In en, this message translates to:
  /// **'Mark answer'**
  String get lessonQuizMark;

  /// No description provided for @lessonQuizNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get lessonQuizNext;

  /// No description provided for @lessonQuizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get lessonQuizFinish;

  /// No description provided for @lessonQuizExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the test?'**
  String get lessonQuizExitTitle;

  /// No description provided for @lessonQuizExitBody.
  ///
  /// In en, this message translates to:
  /// **'If you leave now, your results will not be saved.'**
  String get lessonQuizExitBody;

  /// No description provided for @lessonQuizExitStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get lessonQuizExitStay;

  /// No description provided for @lessonQuizExitLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get lessonQuizExitLeave;

  /// No description provided for @lessonQuizResultGreat.
  ///
  /// In en, this message translates to:
  /// **'Great result!'**
  String get lessonQuizResultGreat;

  /// No description provided for @lessonQuizResultPoor.
  ///
  /// In en, this message translates to:
  /// **'Unsatisfactory result'**
  String get lessonQuizResultPoor;

  /// No description provided for @lessonQuizStatCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get lessonQuizStatCorrect;

  /// No description provided for @lessonQuizStatWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get lessonQuizStatWrong;

  /// No description provided for @lessonQuizStatTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get lessonQuizStatTime;

  /// No description provided for @lessonQuizContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get lessonQuizContinue;

  /// No description provided for @lessonQuizRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get lessonQuizRetry;

  /// No description provided for @lessonQuizErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'This lesson has no test yet.'**
  String get lessonQuizErrorEmpty;

  /// No description provided for @lessonQuizErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load the test.'**
  String get lessonQuizErrorLoad;

  /// No description provided for @lessonQuizErrorCheck.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the answer.'**
  String get lessonQuizErrorCheck;

  /// No description provided for @lessonQuizErrorSubmit.
  ///
  /// In en, this message translates to:
  /// **'Could not submit the test.'**
  String get lessonQuizErrorSubmit;

  /// No description provided for @lessonQuizErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get lessonQuizErrorGeneric;

  /// No description provided for @lessonQuizAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'You have already completed this test. Retakes are not allowed.'**
  String get lessonQuizAlreadyTaken;

  /// No description provided for @courseModuleLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Finish all lessons and tests in the previous module to continue.'**
  String get courseModuleLockedMessage;

  /// No description provided for @courseLessonSequentialLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete the previous lesson and its test (if any) before continuing.'**
  String get courseLessonSequentialLockedMessage;

  /// No description provided for @courseCompleteCongratsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get courseCompleteCongratsTitle;

  /// No description provided for @courseCompleteCongratsDescription.
  ///
  /// In en, this message translates to:
  /// **'You have completed this course. Claim your certificate in the certificates section.'**
  String get courseCompleteCongratsDescription;

  /// No description provided for @courseCompleteGetCertificate.
  ///
  /// In en, this message translates to:
  /// **'Get certificate'**
  String get courseCompleteGetCertificate;

  /// No description provided for @courseCompleteClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get courseCompleteClose;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Top learners'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking of the best students'**
  String get leaderboardSubtitle;

  /// No description provided for @leaderboardTabOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get leaderboardTabOverall;

  /// No description provided for @leaderboardTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get leaderboardTabWeekly;

  /// No description provided for @leaderboardTabMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get leaderboardTabMonthly;

  /// No description provided for @leaderboardSelectCourse.
  ///
  /// In en, this message translates to:
  /// **'Choose a course'**
  String get leaderboardSelectCourse;

  /// No description provided for @leaderboardFullRanking.
  ///
  /// In en, this message translates to:
  /// **'Full ranking'**
  String get leaderboardFullRanking;

  /// No description provided for @leaderboardNoCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get leaderboardNoCourses;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @leaderboardNoRatingYet.
  ///
  /// In en, this message translates to:
  /// **'No ranking for this course yet'**
  String get leaderboardNoRatingYet;

  /// No description provided for @promotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Join in!'**
  String get promotionTitle;

  /// No description provided for @promotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Finish courses and earn points'**
  String get promotionSubtitle;

  /// No description provided for @promotionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get promotionStart;

  /// No description provided for @profileStatCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get profileStatCourses;

  /// No description provided for @profileStatCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get profileStatCertificates;

  /// No description provided for @profileStatRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get profileStatRating;

  /// No description provided for @profileStatPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profileStatPoints;

  /// No description provided for @profileMenuCertificates.
  ///
  /// In en, this message translates to:
  /// **'My certificates'**
  String get profileMenuCertificates;

  /// No description provided for @profileMenuMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My courses'**
  String get profileMenuMyCourses;

  /// No description provided for @profileMenuMyActivity.
  ///
  /// In en, this message translates to:
  /// **'My activity'**
  String get profileMenuMyActivity;

  /// No description provided for @dailyCoinStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day streak} other{{count} days streak}}'**
  String dailyCoinStreakTitle(int count);

  /// No description provided for @dailyCoinStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are on the right track'**
  String get dailyCoinStreakSubtitle;

  /// No description provided for @dailyCoinDayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dailyCoinDayToday;

  /// No description provided for @dailyCoinDayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dailyCoinDayTomorrow;

  /// No description provided for @dailyCoinDayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dailyCoinDayNumber(int day);

  /// No description provided for @dailyCoinRewardToday.
  ///
  /// In en, this message translates to:
  /// **'+{coins} coins today'**
  String dailyCoinRewardToday(int coins);

  /// No description provided for @dailyCoinClaimButton.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get dailyCoinClaimButton;

  /// No description provided for @dailyCoinClaimedButton.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get dailyCoinClaimedButton;

  /// No description provided for @dailyCoinLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load streak. Try again.'**
  String get dailyCoinLoadError;

  /// No description provided for @dailyCoinClaimError.
  ///
  /// In en, this message translates to:
  /// **'Could not claim reward. Try again later.'**
  String get dailyCoinClaimError;

  /// No description provided for @activityScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityScreenTitle;

  /// No description provided for @activityTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get activityTabWeekly;

  /// No description provided for @activityTabMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get activityTabMonthly;

  /// No description provided for @activitySectionStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get activitySectionStats;

  /// No description provided for @activityStatTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Your total time in the app'**
  String get activityStatTotalTime;

  /// No description provided for @activityStatAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Your average time'**
  String get activityStatAverageTime;

  /// No description provided for @activityStatDailyRecord.
  ///
  /// In en, this message translates to:
  /// **'Your daily record'**
  String get activityStatDailyRecord;

  /// No description provided for @activityStatCoursesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Total courses completed'**
  String get activityStatCoursesCompleted;

  /// No description provided for @activityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load activity. Try again.'**
  String get activityLoadError;

  /// No description provided for @activityDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String activityDurationMinutes(int minutes);

  /// No description provided for @activityDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String activityDurationHours(int hours);

  /// No description provided for @activityDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String activityDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @activityCompletedCourses.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String activityCompletedCourses(int count);

  /// No description provided for @profileMenuVacancies.
  ///
  /// In en, this message translates to:
  /// **'Vacancies'**
  String get profileMenuVacancies;

  /// No description provided for @vacanciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacancies'**
  String get vacanciesTitle;

  /// No description provided for @vacancyDetailCta.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get vacancyDetailCta;

  /// No description provided for @vacancySalaryNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Salary negotiable'**
  String get vacancySalaryNegotiable;

  /// No description provided for @vacancySalaryRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to} {currency}'**
  String vacancySalaryRange(String from, String to, String currency);

  /// No description provided for @vacancyPostedMomentsAgo.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get vacancyPostedMomentsAgo;

  /// No description provided for @vacancyPostedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String vacancyPostedMinutesAgo(int count);

  /// No description provided for @vacancyPostedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String vacancyPostedHoursAgo(int count);

  /// No description provided for @vacancyPostedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get vacancyPostedYesterday;

  /// No description provided for @vacancyPostedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String vacancyPostedDaysAgo(int count);

  /// No description provided for @vacancyEmploymentIntern.
  ///
  /// In en, this message translates to:
  /// **'Internship'**
  String get vacancyEmploymentIntern;

  /// No description provided for @vacancyEmploymentPartTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get vacancyEmploymentPartTime;

  /// No description provided for @vacancyEmploymentFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get vacancyEmploymentFullTime;

  /// No description provided for @vacancyEmploymentRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get vacancyEmploymentRemote;

  /// No description provided for @vacancyEmploymentOnsite.
  ///
  /// In en, this message translates to:
  /// **'On-site'**
  String get vacancyEmploymentOnsite;

  /// No description provided for @vacancyEmploymentContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get vacancyEmploymentContract;

  /// No description provided for @vacanciesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vacancies yet'**
  String get vacanciesEmptyTitle;

  /// No description provided for @vacanciesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check back later'**
  String get vacanciesEmptySubtitle;

  /// No description provided for @vacanciesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load vacancies'**
  String get vacanciesLoadError;

  /// No description provided for @vacanciesLoadMoreError.
  ///
  /// In en, this message translates to:
  /// **'Could not load more'**
  String get vacanciesLoadMoreError;

  /// No description provided for @vacancyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacancy'**
  String get vacancyDetailsTitle;

  /// No description provided for @vacancySheetEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment type'**
  String get vacancySheetEmploymentType;

  /// No description provided for @vacancySheetSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get vacancySheetSalary;

  /// No description provided for @vacancySheetLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get vacancySheetLocation;

  /// No description provided for @vacancySheetCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get vacancySheetCategory;

  /// No description provided for @vacancySheetPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get vacancySheetPosted;

  /// No description provided for @vacancyDetailAbout.
  ///
  /// In en, this message translates to:
  /// **'About the vacancy'**
  String get vacancyDetailAbout;

  /// No description provided for @vacancyDetailSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get vacancyDetailSkills;

  /// No description provided for @vacancyDetailRequirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get vacancyDetailRequirements;

  /// No description provided for @vacancyApplyCta.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get vacancyApplyCta;

  /// No description provided for @vacancySalaryPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get vacancySalaryPerMonth;

  /// No description provided for @vacancyDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load vacancy'**
  String get vacancyDetailLoadError;

  /// No description provided for @vacancyApplyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — application will be available here'**
  String get vacancyApplyPlaceholder;

  /// No description provided for @profileMenuProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile information'**
  String get profileMenuProfileInfo;

  /// No description provided for @profileMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileMenuLanguage;

  /// No description provided for @profileMenuShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the app'**
  String get profileMenuShareApp;

  /// No description provided for @profileShareAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and family'**
  String get profileShareAppSubtitle;

  /// No description provided for @profileShareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Qizlar Academy brings free courses, a vibrant community, and room to grow for women and girls — all in one app.\n\nDownload and learn together:\n{link}'**
  String profileShareAppMessage(String link);

  /// No description provided for @profileMenuAbout.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get profileMenuAbout;

  /// No description provided for @profileMenuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get profileMenuHelp;

  /// No description provided for @profileMenuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profileMenuPrivacy;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get profileSectionAccount;

  /// No description provided for @profileCertificatesCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} certificates'**
  String profileCertificatesCountSubtitle(int count);

  /// No description provided for @profileActiveCoursesCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} active courses'**
  String profileActiveCoursesCountSubtitle(int count);

  /// No description provided for @profileSectionSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get profileSectionSettings;

  /// No description provided for @profileSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get profileSectionGeneral;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push messages'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get profileDarkMode;

  /// No description provided for @profileDarkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark interface'**
  String get profileDarkModeSubtitle;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to leave the app?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll be waiting for you in new lessons.\nDo you want to log out now?'**
  String get profileLogoutConfirmBody;

  /// No description provided for @profileLogoutStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get profileLogoutStay;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String profileVersion(String version);

  /// No description provided for @profileDataMissing.
  ///
  /// In en, this message translates to:
  /// **'Profile data is not available.'**
  String get profileDataMissing;

  /// No description provided for @profileInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileInformationTitle;

  /// No description provided for @profileInformationSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileInformationSave;

  /// No description provided for @profileInformationSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileInformationSaveSuccess;

  /// No description provided for @profileInformationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your first and last name'**
  String get profileInformationNameRequired;

  /// No description provided for @profileInformationNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes to save'**
  String get profileInformationNoChanges;

  /// No description provided for @profileInformationPhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the photo. Try again.'**
  String get profileInformationPhotoUploadFailed;

  /// No description provided for @profileInformationPhotoPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access is off. You can enable it in Settings.'**
  String get profileInformationPhotoPermissionDenied;

  /// No description provided for @profileInformationPhotoPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not select the photo. Try again.'**
  String get profileInformationPhotoPickFailed;

  /// No description provided for @profileInformationStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile status'**
  String get profileInformationStatusTitle;

  /// No description provided for @profileInformationPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileInformationPhoneLabel;

  /// No description provided for @profileInformationPhoneNationalHint.
  ///
  /// In en, this message translates to:
  /// **'XX XXX XX XX'**
  String get profileInformationPhoneNationalHint;

  /// No description provided for @editProfileUnsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get editProfileUnsavedTitle;

  /// No description provided for @editProfileUnsavedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes to your profile. Save before leaving?'**
  String get editProfileUnsavedMessage;

  /// No description provided for @editProfileUnsavedSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editProfileUnsavedSave;

  /// No description provided for @editProfileUnsavedDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard and leave'**
  String get editProfileUnsavedDiscard;

  /// No description provided for @editProfileUnsavedContinue.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get editProfileUnsavedContinue;

  /// No description provided for @aboutBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'QIZLAR AKADEMIYASI'**
  String get aboutBrandTitle;

  /// No description provided for @aboutSectionProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Qizlar Academy project'**
  String get aboutSectionProjectTitle;

  /// No description provided for @aboutProjectLead.
  ///
  /// In en, this message translates to:
  /// **'Qizlar Academy'**
  String get aboutProjectLead;

  /// No description provided for @aboutProjectBody.
  ///
  /// In en, this message translates to:
  /// **' – is an interactive platform offering free learning courses for women and girls of all ages. It covers health, modern professions, crafts, education, entrepreneurship, psychology, and law. Sign up and grow your knowledge and skills across many fields through the platform.'**
  String get aboutProjectBody;

  /// No description provided for @aboutSectionSupportersTitle.
  ///
  /// In en, this message translates to:
  /// **'Supporting us'**
  String get aboutSectionSupportersTitle;

  /// No description provided for @aboutSupporterSadullaName.
  ///
  /// In en, this message translates to:
  /// **'Alisher Sadullayev'**
  String get aboutSupporterSadullaName;

  /// No description provided for @aboutSupporterSadullaRole.
  ///
  /// In en, this message translates to:
  /// **'Director of the Youth Affairs Agency of the Republic of Uzbekistan'**
  String get aboutSupporterSadullaRole;

  /// No description provided for @aboutSupporterKattaxonName.
  ///
  /// In en, this message translates to:
  /// **'Dilnoza Kattaxonova'**
  String get aboutSupporterKattaxonName;

  /// No description provided for @aboutSupporterKattaxonRole.
  ///
  /// In en, this message translates to:
  /// **'First deputy director of the Youth Affairs Agency. Doctor of Philosophy in political science'**
  String get aboutSupporterKattaxonRole;

  /// No description provided for @aboutSectionSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social networks'**
  String get aboutSectionSocialTitle;

  /// No description provided for @aboutSocialInstagramTitle.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get aboutSocialInstagramTitle;

  /// No description provided for @aboutSocialInstagramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official Qizlar Academy Instagram channel'**
  String get aboutSocialInstagramSubtitle;

  /// No description provided for @aboutSocialTelegramTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get aboutSocialTelegramTitle;

  /// No description provided for @aboutSocialTelegramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official Qizlar Academy Telegram channel'**
  String get aboutSocialTelegramSubtitle;

  /// No description provided for @aboutSocialYoutubeTitle.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get aboutSocialYoutubeTitle;

  /// No description provided for @aboutSocialYoutubeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official Qizlar Academy YouTube channel'**
  String get aboutSocialYoutubeSubtitle;

  /// No description provided for @aboutUsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load content. Try again.'**
  String get aboutUsLoadError;

  /// No description provided for @aboutUsLinkOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get aboutUsLinkOpenError;

  /// No description provided for @guestGateNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Sign up to manage notification settings'**
  String get guestGateNotificationSettings;

  /// No description provided for @guestGateSaveSettings.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save settings'**
  String get guestGateSaveSettings;

  /// No description provided for @guestGateProfileFeatures.
  ///
  /// In en, this message translates to:
  /// **'Sign up to use profile features'**
  String get guestGateProfileFeatures;

  /// No description provided for @profileAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get profileAppLanguageTitle;

  /// No description provided for @profileBadgePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your badges'**
  String get profileBadgePickerTitle;

  /// No description provided for @profileTezKundaTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileTezKundaTitle;

  /// No description provided for @profileTezKundaMessage.
  ///
  /// In en, this message translates to:
  /// **'This section is not available yet. We\'re working on it — check back soon.'**
  String get profileTezKundaMessage;

  /// No description provided for @languageUzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get languageUzbek;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'New messages will appear here.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationTabPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get notificationTabPlatform;

  /// No description provided for @notificationTabCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get notificationTabCommunity;

  /// No description provided for @notificationDetailsMore.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get notificationDetailsMore;

  /// No description provided for @notificationsEmptyThisTab.
  ///
  /// In en, this message translates to:
  /// **'No notifications in this tab'**
  String get notificationsEmptyThisTab;

  /// No description provided for @notificationsEmptyThisTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch tabs or check back later.'**
  String get notificationsEmptyThisTabSubtitle;

  /// No description provided for @guestGateMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Sign up to mark all as read'**
  String get guestGateMarkAllRead;

  /// No description provided for @guestGateManageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign up to manage notifications'**
  String get guestGateManageNotifications;

  /// No description provided for @guestModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestModeTitle;

  /// No description provided for @guestModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to use every feature.'**
  String get guestModeDescription;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @homeGuestCardSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get homeGuestCardSignIn;

  /// No description provided for @myCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'My courses'**
  String get myCoursesTitle;

  /// No description provided for @myCoursesRatingReviewsLine.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({reviewsCount} reviews)'**
  String myCoursesRatingReviewsLine(String rating, String reviewsCount);

  /// No description provided for @myCoursesDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String myCoursesDurationHours(int hours);

  /// No description provided for @courseDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String courseDurationMinutes(int minutes);

  /// No description provided for @courseDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String courseDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @myCoursesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get myCoursesEmptyTitle;

  /// No description provided for @myCoursesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enroll in a course and it will show up here.'**
  String get myCoursesEmptySubtitle;

  /// No description provided for @myCoursesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your courses. Try again.'**
  String get myCoursesLoadError;

  /// No description provided for @myCoursesLoadMoreError.
  ///
  /// In en, this message translates to:
  /// **'Could not load more. Scroll to try again.'**
  String get myCoursesLoadMoreError;

  /// No description provided for @certificatesBadgeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold certificate'**
  String get certificatesBadgeGold;

  /// No description provided for @certificatesBadgeSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver certificate'**
  String get certificatesBadgeSilver;

  /// No description provided for @certificatesBadgeBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze certificate'**
  String get certificatesBadgeBronze;

  /// No description provided for @linkPromptYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get linkPromptYes;

  /// No description provided for @linkPromptNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get linkPromptNo;

  /// No description provided for @communityTelegramInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Join our community'**
  String get communityTelegramInviteTitle;

  /// No description provided for @communityTelegramInviteDescription.
  ///
  /// In en, this message translates to:
  /// **'You can find answers to your questions on our Telegram channel. Open our Telegram channel?'**
  String get communityTelegramInviteDescription;

  /// No description provided for @certificatesView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get certificatesView;

  /// No description provided for @certificatesSheetHeading.
  ///
  /// In en, this message translates to:
  /// **'{courseName} certificate'**
  String certificatesSheetHeading(String courseName);

  /// No description provided for @certificatesSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'You have successfully completed the course and earned a certificate. May your knowledge always stay with you!'**
  String get certificatesSheetDescription;

  /// No description provided for @certificatesSheetDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get certificatesSheetDownload;

  /// No description provided for @certificatesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No certificates yet'**
  String get certificatesEmptyTitle;

  /// No description provided for @certificatesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you finish a course, your certificate will appear here.'**
  String get certificatesEmptySubtitle;

  /// No description provided for @certificatesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load certificates. Try again.'**
  String get certificatesLoadError;

  /// No description provided for @certificateClaimError.
  ///
  /// In en, this message translates to:
  /// **'Could not get your certificate. Try again later.'**
  String get certificateClaimError;

  /// No description provided for @certificatesFileActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not download or share the file.'**
  String get certificatesFileActionError;

  /// No description provided for @certificatesInstagramStoryNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Instagram Story needs a Facebook App ID. Add FACEBOOK_APP_ID when building the app.'**
  String get certificatesInstagramStoryNotConfigured;

  /// No description provided for @certificatesInstagramShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Instagram. Check that Instagram is installed and try again.'**
  String get certificatesInstagramShareFailed;

  /// No description provided for @courseReviewsSummaryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String courseReviewsSummaryCount(int count);

  /// No description provided for @courseReviewsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get courseReviewsEmptyTitle;

  /// No description provided for @courseReviewsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When learners leave feedback, it will show up here.'**
  String get courseReviewsEmptySubtitle;

  /// No description provided for @courseLeaveReviewCta.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get courseLeaveReviewCta;

  /// No description provided for @courseSubmitReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get courseSubmitReviewTitle;

  /// No description provided for @courseSubmitReviewRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this course'**
  String get courseSubmitReviewRateTitle;

  /// No description provided for @courseSubmitReviewRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What do you think about what you learned and the lesson quality? Share your thoughts.'**
  String get courseSubmitReviewRateSubtitle;

  /// No description provided for @courseSubmitReviewYourCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get courseSubmitReviewYourCommentLabel;

  /// No description provided for @courseSubmitReviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Did you enjoy the course? Share your impressions'**
  String get courseSubmitReviewCommentHint;

  /// No description provided for @courseSubmitReviewCharCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String courseSubmitReviewCharCount(int current, int max);

  /// No description provided for @courseSubmitReviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get courseSubmitReviewSubmit;

  /// No description provided for @courseSubmitReviewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your review was sent'**
  String get courseSubmitReviewSuccess;

  /// No description provided for @courseSubmitReviewError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit the review. Please try again.'**
  String get courseSubmitReviewError;

  /// No description provided for @courseSubmitReviewSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get courseSubmitReviewSelectRating;

  /// No description provided for @reviewTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get reviewTimeJustNow;

  /// No description provided for @reviewTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String reviewTimeMinutesAgo(int count);

  /// No description provided for @reviewTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String reviewTimeHoursAgo(int count);

  /// No description provided for @reviewTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String reviewTimeDaysAgo(int count);

  /// No description provided for @reviewTimeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} wk ago'**
  String reviewTimeWeeksAgo(int count);

  /// No description provided for @reviewTimeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} mo ago'**
  String reviewTimeMonthsAgo(int count);

  /// No description provided for @reviewTimeYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} y ago'**
  String reviewTimeYearsAgo(int count);

  /// No description provided for @personalInfoGateSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get personalInfoGateSubmitError;

  /// No description provided for @personalInfoGateContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get personalInfoGateContinue;

  /// No description provided for @personalInfoGateAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get personalInfoGateAddressTitle;

  /// No description provided for @personalInfoGateAddressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your region, district, and neighborhood.'**
  String get personalInfoGateAddressSubtitle;

  /// No description provided for @personalInfoGateCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get personalInfoGateCountry;

  /// No description provided for @personalInfoGateRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get personalInfoGateRegion;

  /// No description provided for @personalInfoGateDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get personalInfoGateDistrict;

  /// No description provided for @personalInfoGateNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get personalInfoGateNeighborhood;

  /// No description provided for @personalInfoGatePersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInfoGatePersonalInfoTitle;

  /// No description provided for @personalInfoGatePersonalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your date of birth.'**
  String get personalInfoGatePersonalInfoSubtitle;

  /// No description provided for @personalInfoGateBirthday.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get personalInfoGateBirthday;

  /// No description provided for @personalInfoGateEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get personalInfoGateEducationTitle;

  /// No description provided for @personalInfoGateEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your education type.'**
  String get personalInfoGateEducationSubtitle;

  /// No description provided for @courseDetailsShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share course'**
  String get courseDetailsShareTooltip;

  /// No description provided for @courseDetailsShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out \"{title}\": {url}'**
  String courseDetailsShareMessage(String title, String url);

  /// No description provided for @portfolioShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share portfolio post'**
  String get portfolioShareTooltip;

  /// No description provided for @portfolioShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Qizlar Academy — Portfolio'**
  String get portfolioShareSubject;

  /// No description provided for @portfolioShareMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{caption}\"\n\nView this portfolio project in Qizlar Academy:\n{url}'**
  String portfolioShareMessage(String caption, String url);

  /// No description provided for @portfolioShareMessageWithoutCaption.
  ///
  /// In en, this message translates to:
  /// **'View this portfolio project in Qizlar Academy:\n{url}'**
  String portfolioShareMessageWithoutCaption(String url);

  /// No description provided for @portfolioShareError.
  ///
  /// In en, this message translates to:
  /// **'Could not share the post. Please try again.'**
  String get portfolioShareError;

  /// No description provided for @certificatesSheetInstagramStory.
  ///
  /// In en, this message translates to:
  /// **'Instagram Story'**
  String get certificatesSheetInstagramStory;

  /// No description provided for @profileDeleteAccountTile.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccountTile;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account. You can also request deletion on the web: {webUrl}'**
  String profileDeleteAccountConfirmBody(String webUrl);

  /// No description provided for @profileDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileDeleteAccountCancel;

  /// No description provided for @profileDeleteAccountContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get profileDeleteAccountContinue;

  /// No description provided for @profileDeleteAccountFinalTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get profileDeleteAccountFinalTitle;

  /// No description provided for @profileDeleteAccountFinalBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Your data will be removed.'**
  String get profileDeleteAccountFinalBody;

  /// No description provided for @profileDeleteAccountConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteAccountConfirmAction;

  /// No description provided for @profileDeleteAccountProgress.
  ///
  /// In en, this message translates to:
  /// **'Deleting account…'**
  String get profileDeleteAccountProgress;

  /// No description provided for @profileDeleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete account. Try again.'**
  String get profileDeleteAccountError;

  /// No description provided for @appUpdateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get appUpdateAvailableTitle;

  /// No description provided for @appUpdateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Update for the best experience.'**
  String get appUpdateAvailableBody;

  /// No description provided for @appUpdateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get appUpdateLater;

  /// No description provided for @appUpdateCta.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get appUpdateCta;

  /// No description provided for @profileNotificationsEnableFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update notification settings. Try again.'**
  String get profileNotificationsEnableFailed;

  /// No description provided for @profileInformationPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileInformationPersonalTitle;

  /// No description provided for @profileInformationOccupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get profileInformationOccupation;

  /// No description provided for @profileInformationBirthday.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileInformationBirthday;

  /// No description provided for @profileInformationAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileInformationAddressTitle;

  /// No description provided for @profileInformationRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get profileInformationRegion;

  /// No description provided for @profileInformationDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get profileInformationDistrict;

  /// No description provided for @profileInformationNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get profileInformationNeighborhood;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get storeTitle;

  /// No description provided for @storeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get storeProduct;

  /// No description provided for @storeAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get storeAllCategories;

  /// No description provided for @storeNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get storeNoProducts;

  /// No description provided for @storeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get storeLoadError;

  /// No description provided for @storeLoadMoreError.
  ///
  /// In en, this message translates to:
  /// **'Error loading more'**
  String get storeLoadMoreError;

  /// No description provided for @storeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get storeDetailTitle;

  /// No description provided for @storeAboutProduct.
  ///
  /// In en, this message translates to:
  /// **'About product'**
  String get storeAboutProduct;

  /// No description provided for @storeInStock.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String storeInStock(Object count);

  /// No description provided for @storeSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get storeSoldOut;

  /// No description provided for @storeBuyButton.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get storeBuyButton;

  /// No description provided for @storeReturnButton.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get storeReturnButton;

  /// No description provided for @storeViewButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get storeViewButton;

  /// No description provided for @storeAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get storeAllTypes;

  /// No description provided for @storeSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get storeSize;

  /// No description provided for @storeOrderSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get storeOrderSuccess;

  /// No description provided for @storeOrderError.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get storeOrderError;

  /// No description provided for @storePromoExpired.
  ///
  /// In en, this message translates to:
  /// **'Promo code expired'**
  String get storePromoExpired;

  /// No description provided for @storeInsufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Product out of stock'**
  String get storeInsufficientStock;

  /// No description provided for @storeCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get storeCopied;

  /// No description provided for @storeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get storeHistoryTitle;

  /// No description provided for @storeHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get storeHistoryEmpty;

  /// No description provided for @storeHistoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get storeHistoryLoadError;

  /// No description provided for @storeStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get storeStatusPending;

  /// No description provided for @storeStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get storeStatusPaid;

  /// No description provided for @storeStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get storeStatusShipped;

  /// No description provided for @storeStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get storeStatusDelivered;

  /// No description provided for @storeStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get storeStatusCancelled;

  /// No description provided for @storeStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get storeStatusRefunded;

  /// No description provided for @storeExtraMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get storeExtraMenuTitle;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get offlineTitle;

  /// No description provided for @offlineDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection. The app will continue automatically when you are back online.'**
  String get offlineDescription;

  /// No description provided for @offlineRetry.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get offlineRetry;

  /// No description provided for @offlineWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for an internet connection...'**
  String get offlineWaiting;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'BALANCE'**
  String get tasksBalanceLabel;

  /// No description provided for @tasksCoinLabel.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get tasksCoinLabel;

  /// No description provided for @tasksStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count}-Day Streak'**
  String tasksStreakTitle(int count);

  /// No description provided for @tasksStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it going!'**
  String get tasksStreakSubtitle;

  /// No description provided for @tasksTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get tasksTodayTitle;

  /// No description provided for @tasksOtherTitle.
  ///
  /// In en, this message translates to:
  /// **'Other tasks'**
  String get tasksOtherTitle;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'New tasks will appear here'**
  String get tasksEmptySubtitle;

  /// No description provided for @tasksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tasks. Try again.'**
  String get tasksLoadError;

  /// No description provided for @tasksActionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This task action is not available yet'**
  String get tasksActionUnavailable;

  /// No description provided for @birthdayStoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthdayStoryLabel;

  /// No description provided for @birthdayStoryCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get birthdayStoryCongratulations;

  /// No description provided for @birthdayStoryMessage.
  ///
  /// In en, this message translates to:
  /// **'The Qizlar Akademiyasi team wishes you a very happy birthday!'**
  String get birthdayStoryMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
