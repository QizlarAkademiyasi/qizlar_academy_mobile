import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_args.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/register/pages/register_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_details_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_launch_context.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/screens/my_courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/search/courses_search_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/search/courses_search_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/screens/about_us_screen.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/portfolio_create_screen.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/detail/portfolio_detail_screen.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/screens/my_certificates_screen.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancies_screen.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/vacancy_detail_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/screens/edit_information_screen.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/notification_screen.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/screens/splash_screen.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/store_screen.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/screens/store_detail_screen.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/screens/store_history_screen.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/screens/order_detail/store_order_detail_screen.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/screens/activity_screen.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/screens/referral_screen.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/screens/tasks_screen.dart';

part 'path_routes.dart';

/// `true`: boshlash va OTP/Google dan keyin [SplashScreen] — ma’lumotlar gate + minimal vaqt.
/// Native launch faqat rang (Android/iOS), to‘liq dizayn Flutter splashda.
const bool kShowFlutterSplash = true;

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Barcha tab ekranlari bitta [MainScreen] ichida; [PageView] tab almashganda
/// pastki o‘rnatmalarni qayta yig‘masin — bog‘larni shu yerdan yagona yaratamiz
/// (aks holda har kirishda `..add(Started)` = qayta GET).
Widget _mainShellWithTabBlocs({required bool isGuestMode}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<HomeBloc>()..add(const HomeStarted())),
      BlocProvider(
        create: (_) =>
            getIt<LeaderboardBloc>()..add(const LeaderboardStarted()),
      ),

      /// Mehmon rejimida ham [ProfileBloc] mavjud bo‘lishi kerak: ba’zi overlay /
      /// sheet / routing ketma-ketliklarida `context.read<ProfileBloc>()` chaqiruvi
      /// boshqa tabdagi provider daraxtidan ajralib qolganda **Provider not found**
      /// (Crashlytics: Selector) f(at)al xatolik berardi.
      BlocProvider(
        create: (_) {
          final bloc = getIt<ProfileBloc>();
          if (!isGuestMode) {
            bloc.add(const ProfileStarted());
          }
          return bloc;
        },
      ),
    ],
    child: MainScreen(isGuestMode: isGuestMode),
  );
}

class AppRoute {
  const AppRoute._();

  static String get initialLocation =>
      kShowFlutterSplash ? Routes.splash : Routes.main;

  static GoRouter createRouter(AuthSessionCubit authSessionCubit) {
    return GoRouter(
      debugLogDiagnostics: false,
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      refreshListenable: _RouterRefreshNotifier(authSessionCubit.stream),
      redirect: (context, state) {
        final location = state.matchedLocation;
        final session = authSessionCubit.state;
        final isRegistered = session.isRegistered;
        final isGuest = session.isAnonymous;
        final gateResolved = session.profileGateResolved;
        final needsProfileRegistration = session.needsProfileRegistration;

        if (!session.isInitialized) {
          if (kShowFlutterSplash) {
            return location == Routes.splash ? null : Routes.splash;
          }
          if (location == Routes.splash) {
            return Routes.main;
          }
          return null;
        }

        if (isRegistered && !gateResolved) {
          // Gate hali aniqlanmagan — backendda profile bor-yo‘qligini bilmaymiz.
          // Asynx tarzda gate resolve qilinishini ishga tushiramiz; tugagach
          // [_RouterRefreshNotifier] orqali redirect qayta hisoblanadi.
          unawaited(authSessionCubit.ensureProfileGateResolved());

          if (location == Routes.splash || location == Routes.verification) {
            return null;
          }
          if (kShowFlutterSplash) {
            return Routes.splash;
          }
          // Deeplink yoki push orqali kelgan `/register` ham gate aniqlanmaguncha
          // ko‘rsatilmasin — registered foydalanuvchini main ga yo‘naltiramiz.
          if (location == Routes.register) {
            return Routes.main;
          }
          return null;
        }

        if (location == Routes.splash && !kShowFlutterSplash) {
          return Routes.main;
        }
        // Splash o‘zi animatsiya + minimal vaqt tugagach yo‘naltiradi — ro‘yxatdan o‘tganlar ham har safar splash ko‘radi.
        if (location == Routes.splash) {
          return null;
        }

        if (location == Routes.register) {
          if (!isRegistered) return Routes.signIn;
          if (gateResolved && !needsProfileRegistration) {
            return Routes.mainUser;
          }
          return null;
        }

        if (location == Routes.signIn && isRegistered && gateResolved) {
          return needsProfileRegistration ? Routes.register : Routes.mainUser;
        }

        if (location == Routes.main) {
          if (isRegistered && gateResolved && needsProfileRegistration) {
            return Routes.register;
          }
          return isRegistered ? Routes.mainUser : Routes.mainGuest;
        }
        if (location == Routes.mainGuest && isRegistered) {
          if (gateResolved && needsProfileRegistration) {
            return Routes.register;
          }
          return Routes.mainUser;
        }
        if (location == Routes.mainUser && isGuest) {
          return Routes.mainGuest;
        }
        if (location == Routes.notification && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.myCourses && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.myCertificates && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.vacancies && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/vacancies/[^/]+$').hasMatch(state.uri.path) && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.profileInformation && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.store && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/store/[^/]+$').hasMatch(state.uri.path) && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.storeHistory && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/store-history/[^/]+$').hasMatch(state.uri.path) &&
            isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.referral && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.myActivity && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.tasks && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.portfolioCreate && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/portfolio/[^/]+$').hasMatch(state.uri.path) && isGuest) {
          return Routes.signIn;
        }
        if (state.uri.path.startsWith('/lesson-quiz/') && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/courses/[^/]+/review$').hasMatch(state.uri.path) &&
            isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.lessonQuizResult && isGuest) {
          return Routes.signIn;
        }

        if (isRegistered && gateResolved && needsProfileRegistration) {
          if (location == Routes.verification) return null;
          if (location.startsWith('/courses/')) return Routes.register;
          if (state.uri.path.startsWith('/lesson-quiz/')) {
            return Routes.register;
          }
          if (RegExp(r'^/courses/[^/]+/review$').hasMatch(state.uri.path)) {
            return Routes.register;
          }
          if (location == Routes.lessonQuizResult) return Routes.register;
          if (location == Routes.notification) return Routes.register;
          if (location == Routes.myCourses) return Routes.register;
          if (location == Routes.coursesSearch) return Routes.register;
          if (location == Routes.myCertificates) return Routes.register;
          if (location == Routes.vacancies) return Routes.register;
          if (RegExp(r'^/vacancies/[^/]+$').hasMatch(state.uri.path)) {
            return Routes.register;
          }
          if (location == Routes.profileInformation) return Routes.register;
          if (location == Routes.store) return Routes.register;
          if (RegExp(r'^/store/[^/]+$').hasMatch(state.uri.path)) {
            return Routes.register;
          }
          if (location == Routes.storeHistory) return Routes.register;
          if (RegExp(r'^/store-history/[^/]+$').hasMatch(state.uri.path)) {
            return Routes.register;
          }
          if (location == Routes.referral) return Routes.register;
          if (location == Routes.myActivity) return Routes.register;
          if (location == Routes.tasks) return Routes.register;
          if (location == Routes.portfolioCreate) return Routes.register;
          if (RegExp(r'^/portfolio/[^/]+$').hasMatch(state.uri.path)) {
            return Routes.register;
          }
          if (location == Routes.mainUser) return Routes.register;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.splash,
          name: Routes.splash,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.main,
          name: Routes.main,
          parentNavigatorKey: rootNavigatorKey,
          redirect: (_, state) => authSessionCubit.state.isRegistered
              ? Routes.mainUser
              : Routes.mainGuest,
        ),
        GoRoute(
          path: Routes.mainGuest,
          name: 'mainGuest',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, _) => _mainShellWithTabBlocs(isGuestMode: true),
        ),
        GoRoute(
          path: Routes.mainUser,
          name: 'mainUser',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, _) => _mainShellWithTabBlocs(isGuestMode: false),
        ),
        GoRoute(
          path: Routes.courses,
          name: Routes.coursesName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => BlocProvider(
            create: (_) =>
                getIt<CoursesCatalogBloc>()..add(const CoursesCatalogStarted()),
            child: const CoursesScreen(),
          ),
        ),
        GoRoute(
          path: '/courses/:id',
          name: 'courseDetails',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return CourseDetailsScreen(courseId: id);
          },
        ),
        GoRoute(
          path: '/courses/:id/player',
          name: 'coursePlayer',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            final extra = state.extra;
            if (extra is! CourseLessonPlayerArgs) {
              return CourseDetailsScreen(courseId: id);
            }
            return CourseLessonPlayerScreen(args: extra);
          },
        ),
        GoRoute(
          path: '/courses/:id/review',
          name: Routes.courseSubmitReviewName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            final extra = state.extra;
            if (extra is! CourseSubmitReviewArgs) {
              return CourseDetailsScreen(courseId: id);
            }
            return CourseSubmitReviewScreen(args: extra);
          },
        ),
        GoRoute(
          path: '/lesson-quiz/:lessonId',
          name: 'lessonQuiz',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final lessonId = state.pathParameters['lessonId'] ?? '';
            final extra = state.extra;
            final launch = extra is LessonQuizLaunchContext ? extra : null;
            return LessonQuizScreen(lessonId: lessonId, launchContext: launch);
          },
        ),
        GoRoute(
          path: Routes.lessonQuizResult,
          name: Routes.lessonQuizResultName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! LessonQuizResultArgs) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                context.go(
                  authSessionCubit.state.isRegistered
                      ? Routes.mainUser
                      : Routes.mainGuest,
                );
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return LessonQuizResultScreen(args: extra);
          },
        ),
        GoRoute(
          path: Routes.notification,
          name: Routes.notificationName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const NotificationScreen(),
        ),
        GoRoute(
          path: Routes.myCourses,
          name: Routes.myCoursesName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const MyCoursesScreen(),
        ),
        GoRoute(
          path: Routes.coursesSearch,
          name: Routes.coursesSearchName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! CoursesSearchArgs) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ),
              );
            }
            return BlocProvider.value(
              value: extra.catalogBloc,
              child: CoursesSearchScreen(initialQuery: extra.initialQuery),
            );
          },
        ),
        GoRoute(
          path: Routes.myCertificates,
          name: Routes.myCertificatesName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const MyCertificatesScreen(),
        ),
        GoRoute(
          path: Routes.vacancies,
          name: Routes.vacanciesName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const VacanciesScreen(),
        ),
        GoRoute(
          path: '/vacancies/:vacancyId',
          name: Routes.vacancyDetailName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['vacancyId'] ?? '';
            return VacancyDetailScreen(vacancyId: id);
          },
        ),
        GoRoute(
          path: Routes.profileInformation,
          name: Routes.profileInformationName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, state) {
            final extra = state.extra;
            final seed = extra is ProfileUserModel ? extra : null;
            return EditInformationScreen(seedUser: seed);
          },
        ),
        GoRoute(
          path: Routes.aboutUs,
          name: Routes.aboutUsName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const AboutUsScreen(),
        ),
        GoRoute(
          path: Routes.privacyPolicy,
          name: Routes.privacyPolicyName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: Routes.store,
          name: Routes.storeName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const StoreScreen(),
        ),
        GoRoute(
          path: '/store/:id',
          name: Routes.storeDetailName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return StoreDetailScreen(productId: id);
          },
        ),
        GoRoute(
          path: Routes.storeHistory,
          name: Routes.storeHistoryName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const StoreHistoryScreen(),
        ),
        GoRoute(
          path: '/store-history/:orderId',
          name: Routes.storeOrderDetailName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final orderId = state.pathParameters['orderId'] ?? '';
            return StoreOrderDetailScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: Routes.referral,
          name: Routes.referralName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const ReferralScreen(),
        ),
        GoRoute(
          path: Routes.myActivity,
          name: Routes.myActivityName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const ActivityScreen(),
        ),
        GoRoute(
          path: Routes.tasks,
          name: Routes.tasksName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const TasksScreen(),
        ),
        GoRoute(
          path: Routes.portfolio,
          name: Routes.portfolioName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const PortfolioScreen(),
        ),
        GoRoute(
          path: Routes.portfolioCreate,
          name: Routes.portfolioCreateName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const PortfolioCreateScreen(),
        ),
        GoRoute(
          path: '/portfolio/:postId',
          name: Routes.portfolioDetailName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['postId'] ?? '';
            return PortfolioDetailScreen(postId: id);
          },
        ),
        GoRoute(
          path: Routes.signIn,
          name: Routes.signIn,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const SignInScreen(),
        ),
        GoRoute(
          path: Routes.verification,
          name: Routes.verification,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, state) {
            final extra = state.extra;
            if (extra is! VerificationArgs) return const SignInScreen();
            return VerificationScreen(args: extra);
          },
        ),
        GoRoute(
          path: Routes.register,
          name: Routes.register,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, _) => const RegisterScreen(),
        ),
      ],
    );
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
