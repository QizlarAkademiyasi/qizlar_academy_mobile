import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_args.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_screen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/register_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_details_screen.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_screen.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen.dart';
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
        if (!authSessionCubit.state.isInitialized) {
          return location == Routes.splash ? null : Routes.splash;
        }
        if (location == Routes.splash) return Routes.main;
        if (location == Routes.signIn && authSessionCubit.state.isRegistered) {
          return Routes.main;
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
          builder: (context, _) => BlocProvider(
            create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
            child: MainScreen(key: ValueKey(authSessionCubit.state.userType)),
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
          path: Routes.notification,
          name: Routes.notificationName,
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, _) => const NotificationScreen(),
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
