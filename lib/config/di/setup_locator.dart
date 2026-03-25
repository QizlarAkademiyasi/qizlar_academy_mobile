import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/config/settings/settings_data_source.dart';
import 'package:qizlar_academy_mobile/core/network/api_client.dart';
import 'package:qizlar_academy_mobile/core/network/app_network_logger_interceptor.dart';
import 'package:qizlar_academy_mobile/core/network/insecure_ssl_override.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/repository/courses_catalog_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/data/datasource/courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/data/datasource/courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/data/repository/courses_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/bloc/course_details_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/repository/leaderboard_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/data/repository/home_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/repository/notification_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/datasource/profile_datasource.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/firebase_options.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppRemoteConfig.initialize();

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SettingsDataSource>(SettingsDataSourceImpl(prefs));
  getIt.registerSingleton<AuthLocalDatasource>(AuthLocalDatasourceImpl(prefs));
  final authRemoteDio = Dio(
    BaseOptions(
      baseUrl: AppRemoteConfig.instance.domain,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  applyInsecureSslOverride(authRemoteDio);
  authRemoteDio.interceptors.add(AppNetworkLoggerInterceptor());
  getIt.registerSingleton<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(authRemoteDio),
  );
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthLocalDatasource>(),
      getIt<AuthRemoteDatasource>(),
    ),
  );
  getIt.registerSingleton<AuthSessionCubit>(
    AuthSessionCubit(getIt<AuthRepository>()),
  );
  await getIt<AuthSessionCubit>().loadSession();
  getIt.registerSingleton<GuestTapGateService>(GuestTapGateService());
  getIt.registerSingleton<Dio>(
    ApiClientFactory.create(getIt<AuthSessionCubit>()),
  );

  getIt.registerSingleton<AppOptionsService>(
    AppOptionsService(getIt<SettingsDataSource>()),
  );
  getIt.registerSingleton<GoRouter>(
    AppRoute.createRouter(getIt<AuthSessionCubit>()),
  );

  getIt.registerLazySingleton<HomeApiDatasource>(
    () => HomeApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeDatasource>(() => getIt<HomeApiDatasource>());
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      apiDatasource: getIt<HomeApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<HomeRepository>()));

  getIt.registerLazySingleton<CoursesCatalogApiDatasource>(
    () => CoursesCatalogApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoursesCatalogDatasource>(
    () => getIt<CoursesCatalogApiDatasource>(),
  );
  getIt.registerLazySingleton<CoursesCatalogRepository>(
    () => CoursesCatalogRepositoryImpl(
      apiDatasource: getIt<CoursesCatalogApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<CoursesCatalogBloc>(
    () => CoursesCatalogBloc(getIt<CoursesCatalogRepository>()),
  );

  getIt.registerLazySingleton<CoursesApiDatasource>(
    () => CoursesApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoursesDatasource>(
    () => getIt<CoursesApiDatasource>(),
  );
  getIt.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(
      apiDatasource: getIt<CoursesApiDatasource>(),
    ),
  );
  getIt.registerFactory<CourseDetailsBloc>(
    () => CourseDetailsBloc(getIt<CoursesRepository>()),
  );

  getIt.registerLazySingleton<LeaderboardApiDatasource>(
    () => LeaderboardApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<LeaderboardDatasource>(
    () => getIt<LeaderboardApiDatasource>(),
  );
  getIt.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(
      apiDatasource: getIt<LeaderboardApiDatasource>(),
    ),
  );
  getIt.registerFactory<LeaderboardBloc>(
    () => LeaderboardBloc(getIt<LeaderboardRepository>()),
  );

  getIt.registerLazySingleton<ProfileApiDatasource>(
    () => ProfileApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileDatasource>(
    () => getIt<ProfileApiDatasource>(),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      apiDatasource: getIt<ProfileApiDatasource>(),
    ),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<NotificationApiDatasource>(
    () => NotificationApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationDatasource>(
    () => getIt<NotificationApiDatasource>(),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      apiDatasource: getIt<NotificationApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(getIt<NotificationRepository>()),
  );
}
