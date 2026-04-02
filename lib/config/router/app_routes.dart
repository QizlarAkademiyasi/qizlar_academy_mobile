import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_args.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/register_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_details_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_result_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/lesson_quiz_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_screen.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/screens/my_courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/screens/about_us_screen.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/screens/my_certificates_screen.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/screens/edit_information_screen.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/screens/notification_screen.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/screens/splash_screen.dart';

part 'path_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoute {
  const AppRoute._();

  static const String initialLocation = Routes.splash;

  static GoRouter createRouter(AuthSessionCubit authSessionCubit) {
    return GoRouter(
      debugLogDiagnostics: true,
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
          return location == Routes.splash ? null : Routes.splash;
        }

        if (isRegistered && !gateResolved) {
          if (location == Routes.splash || location == Routes.verification) {
            return null;
          }
          return Routes.splash;
        }

        if (location == Routes.splash) {
          if (isGuest) return Routes.mainGuest;
          if (isRegistered && needsProfileRegistration) {
            return Routes.register;
          }
          if (isRegistered) return Routes.mainUser;
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
        if (location == Routes.profileInformation && isGuest) {
          return Routes.signIn;
        }
        if (state.uri.path.startsWith('/lesson-quiz/') && isGuest) {
          return Routes.signIn;
        }
        if (RegExp(r'^/courses/[^/]+/review$').hasMatch(state.uri.path) && isGuest) {
          return Routes.signIn;
        }
        if (location == Routes.lessonQuizResult && isGuest) {
          return Routes.signIn;
        }

        if (isRegistered && gateResolved && needsProfileRegistration) {
          if (location == Routes.verification) return null;
          if (location.startsWith('/courses/')) return Routes.register;
          if (state.uri.path.startsWith('/lesson-quiz/')) return Routes.register;
          if (RegExp(r'^/courses/[^/]+/review$').hasMatch(state.uri.path)) return Routes.register;
          if (location == Routes.lessonQuizResult) return Routes.register;
          if (location == Routes.notification) return Routes.register;
          if (location == Routes.myCourses) return Routes.register;
          if (location == Routes.myCertificates) return Routes.register;
          if (location == Routes.profileInformation) return Routes.register;
          if (location == Routes.mainUser) return Routes.register;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(path: Routes.splash, name: Routes.splash, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const SplashScreen()),
        GoRoute(path: Routes.main, name: Routes.main, parentNavigatorKey: rootNavigatorKey, redirect: (_, state) => authSessionCubit.state.isRegistered ? Routes.mainUser : Routes.mainGuest),
        GoRoute(
          path: Routes.mainGuest,
          name: 'mainGuest',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, _) => BlocProvider(create: (_) => getIt<HomeBloc>()..add(const HomeStarted()), child: const MainScreen(isGuestMode: true)),
        ),
        GoRoute(
          path: Routes.mainUser,
          name: 'mainUser',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, _) => BlocProvider(create: (_) => getIt<HomeBloc>()..add(const HomeStarted()), child: const MainScreen(isGuestMode: false)),
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
            return LessonQuizScreen(lessonId: lessonId);
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
                context.go(authSessionCubit.state.isRegistered ? Routes.mainUser : Routes.mainGuest);
              });
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return LessonQuizResultScreen(args: extra);
          },
        ),
        GoRoute(path: Routes.notification, name: Routes.notificationName, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const NotificationScreen()),
        GoRoute(path: Routes.myCourses, name: Routes.myCoursesName, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const MyCoursesScreen()),
        GoRoute(path: Routes.myCertificates, name: Routes.myCertificatesName, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const MyCertificatesScreen()),
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
        GoRoute(path: Routes.aboutUs, name: Routes.aboutUsName, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const AboutUsScreen()),
        GoRoute(path: Routes.signIn, name: Routes.signIn, parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const SignInScreen()),
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
        GoRoute(path: Routes.register, name: Routes.register, parentNavigatorKey: rootNavigatorKey, builder: (context, _) => const RegisterScreen()),
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
