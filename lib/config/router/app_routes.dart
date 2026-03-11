import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/home_screen.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/screens/splash_screen.dart';

part 'path_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoute {
  const AppRoute._();

  static const String initialLocation = Routes.splash;

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
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
          child: const MainScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        name: Routes.home,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, _) => BlocProvider(
          create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
