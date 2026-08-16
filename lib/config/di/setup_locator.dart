import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/config/settings/settings_data_source.dart';
import 'package:qizlar_academy_mobile/core/network/activity_ping_service.dart';
import 'package:qizlar_academy_mobile/core/network/daily_streak_daily_fetch_service.dart';
import 'package:qizlar_academy_mobile/core/network/api_client.dart';
import 'package:qizlar_academy_mobile/core/network/app_network_logger_interceptor.dart';
import 'package:qizlar_academy_mobile/core/network/insecure_ssl_override.dart';
import 'package:qizlar_academy_mobile/core/network/network_status_service.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/about_us/data/repository/about_us_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/repository/about_us_repository.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/bloc/about_us_bloc.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/data/repository/privacy_policy_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/domain/repository/privacy_policy_repository.dart';
import 'package:qizlar_academy_mobile/feature/privacy_policy/presentation/bloc/privacy_policy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/datasource/portfolio_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/datasource/portfolio_datasource.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/repository/portfolio_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/comments/bloc/portfolio_comments_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/bloc/portfolio_create_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/detail/bloc/portfolio_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/repository/ai_chat_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/repository/courses_catalog_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/lesson_quiz_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/repository/courses_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/repository/lesson_quiz_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/lesson_quiz_repository.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/course_details_bloc.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/datasource/daily_coin_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/data/repository/daily_coin_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/bloc/daily_coin_bloc.dart';
import 'package:qizlar_academy_mobile/feature/tasks/data/datasource/tasks_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/tasks/data/repository/tasks_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/repository/tasks_repository.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/data/repository/leaderboard_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/data/datasource/my_activity_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/data/repository/my_activity_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/bloc/my_activity_bloc.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/data/repository/home_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_startup_snapshot.dart';
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
import 'package:qizlar_academy_mobile/feature/profile/data/service/profile_adaptive_photo_picker.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/service/profile_photo_picker.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/edit_information/bloc/edit_information_bloc.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/data/datasource/vacancy_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/data/datasource/vacancy_datasource.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/data/repository/vacancy_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/repository/vacancy_repository.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/bloc/vacancy_bloc.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/bloc/vacancy_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/data/datasource/my_courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/data/datasource/my_courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/data/repository/my_courses_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/repository/my_courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/course_certificate_claim_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/course_certificate_claim_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/repository/course_certificate_claim_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/repository/my_certificates_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_instagram_story_share.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/location_data_loader.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/personal_info_gate_checker.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/presentation/bloc/personal_info_gate_bloc.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/course_certificate_claim_repository.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/my_certificates_repository.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/bloc/my_certificates_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_coordinator.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_parser.dart';
import 'package:qizlar_academy_mobile/feature/referral/data/datasource/referral_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/referral/data/datasource/referral_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/referral/data/repository/referral_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/repository/referral_repository.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/service/referral_use_service.dart';
import 'package:qizlar_academy_mobile/feature/referral/presentation/bloc/referral_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/data/datasource/store_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/store/data/datasource/store_datasource.dart';
import 'package:qizlar_academy_mobile/feature/store/data/repository/store_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/bloc/store_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/detail_screen/bloc/store_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/bloc/store_history_bloc.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/bloc/order_detail/store_order_detail_bloc.dart';
import 'package:qizlar_academy_mobile/core/analytics/meta_analytics_service.dart';
import 'package:qizlar_academy_mobile/core/push/push_messaging_service.dart';
import 'package:qizlar_academy_mobile/firebase_options.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<NetworkStatusService>(
    NetworkStatusService()..start(),
  );
  await AppRemoteConfig.initialize();
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
  getIt.registerSingleton<ProfileAvatarRefreshNotifier>(
    ProfileAvatarRefreshNotifier(),
  );
  getIt.registerSingleton<Dio>(
    ApiClientFactory.create(getIt<AuthSessionCubit>()),
  );
  getIt.registerSingleton<ActivityPingService>(
    ActivityPingService(getIt<Dio>(), getIt<AuthSessionCubit>()),
  );

  getIt.registerSingleton<AppOptionsService>(
    AppOptionsService(getIt<SettingsDataSource>()),
  );
  getIt.registerSingleton<GoRouter>(
    AppRoute.createRouter(getIt<AuthSessionCubit>()),
  );

  getIt.registerSingleton<ReferralLocalDatasource>(
    ReferralLocalDatasourceImpl(prefs),
  );
  getIt.registerSingleton<ReferralRemoteDatasource>(
    ReferralApiDatasource(getIt<Dio>()),
  );
  getIt.registerSingleton<ReferralRepository>(
    ReferralRepositoryImpl(
      getIt<ReferralLocalDatasource>(),
      getIt<ReferralRemoteDatasource>(),
    ),
  );
  getIt.registerSingleton<ReferralUseService>(
    ReferralUseService(getIt<ReferralRepository>(), getIt<AuthSessionCubit>()),
  );
  getIt.registerFactory<ReferralBloc>(
    () => ReferralBloc(getIt<ReferralRepository>()),
  );

  getIt.registerSingleton<AppDeepLinkParser>(AppDeepLinkParser());
  getIt.registerSingleton<AppDeepLinkCoordinator>(
    AppDeepLinkCoordinator(
      router: getIt<GoRouter>(),
      parser: getIt<AppDeepLinkParser>(),
      referralUseService: getIt<ReferralUseService>(),
    ),
  );
  getIt.registerSingleton<PushMessagingService>(
    PushMessagingService(prefs, getIt<AppDeepLinkCoordinator>()),
  );

  getIt.registerSingleton<MetaAnalyticsService>(MetaAnalyticsService());

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
  getIt.registerSingleton<HomeStartupCache>(HomeStartupCache());
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getIt<HomeRepository>(),
      getIt<ProfileRepository>(),
      getIt<AuthSessionCubit>(),
      getIt<HomeStartupCache>(),
    ),
  );

  getIt.registerLazySingleton<AiChatApiDatasource>(
    () => AiChatApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AiChatDatasource>(
    () => getIt<AiChatApiDatasource>(),
  );
  getIt.registerLazySingleton<AiChatRepository>(
    () => AiChatRepositoryImpl(getIt<AiChatDatasource>()),
  );
  getIt.registerFactory<AiChatBloc>(
    () => AiChatBloc(getIt<AiChatRepository>()),
  );

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
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<CourseDetailsBloc>(
    () => CourseDetailsBloc(
      getIt<CoursesRepository>(),
      getIt<ProfileRepository>(),
    ),
  );

  getIt.registerLazySingleton<LessonQuizApiDatasource>(
    () => LessonQuizApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<LessonQuizRepository>(
    () => LessonQuizRepositoryImpl(getIt<LessonQuizApiDatasource>()),
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
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<LeaderboardBloc>(
    () => LeaderboardBloc(getIt<LeaderboardRepository>()),
  );

  getIt.registerLazySingleton<ProfileApiDatasource>(
    () => ProfileApiDatasource(getIt<Dio>(), prefs),
  );
  getIt.registerLazySingleton<ProfileDatasource>(
    () => getIt<ProfileApiDatasource>(),
  );
  getIt.registerLazySingleton<ProfilePhotoPicker>(
    () => ProfileAdaptivePhotoPicker(),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      apiDatasource: getIt<ProfileApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<LocationDataLoader>(() => LocationDataLoader());
  getIt.registerLazySingleton<PersonalInfoGateChecker>(
    () => PersonalInfoGateChecker(getIt<Dio>(), prefs),
  );
  getIt.registerFactory<PersonalInfoGateBloc>(
    () => PersonalInfoGateBloc(
      getIt<LocationDataLoader>(),
      getIt<ProfileDatasource>(),
      getIt<PersonalInfoGateChecker>(),
    ),
  );
  getIt.registerFactory<EditInformationBloc>(
    () => EditInformationBloc(
      getIt<ProfileRepository>(),
      getIt<LocationDataLoader>(),
    ),
  );

  getIt.registerLazySingleton<MyCoursesApiDatasource>(
    () => MyCoursesApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MyCoursesDatasource>(
    () => getIt<MyCoursesApiDatasource>(),
  );
  getIt.registerLazySingleton<MyCoursesRepository>(
    () => MyCoursesRepositoryImpl(
      apiDatasource: getIt<MyCoursesApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<MyCoursesBloc>(
    () => MyCoursesBloc(getIt<MyCoursesRepository>()),
  );

  getIt.registerLazySingleton<VacancyApiDatasource>(
    () => VacancyApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<VacancyDatasource>(
    () => getIt<VacancyApiDatasource>(),
  );
  getIt.registerLazySingleton<VacancyRepository>(
    () => VacancyRepositoryImpl(
      apiDatasource: getIt<VacancyApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<VacancyBloc>(
    () => VacancyBloc(getIt<VacancyRepository>()),
  );
  getIt.registerFactory<VacancyDetailBloc>(
    () => VacancyDetailBloc(getIt<VacancyRepository>()),
  );

  getIt.registerLazySingleton<MyCertificatesDatasource>(
    () => MyCertificatesApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MyCertificatesRepository>(
    () => MyCertificatesRepositoryImpl(
      datasource: getIt<MyCertificatesDatasource>(),
    ),
  );
  getIt.registerLazySingleton<CourseCertificateClaimDatasource>(
    () => CourseCertificateClaimApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CourseCertificateClaimRepository>(
    () => CourseCertificateClaimRepositoryImpl(
      getIt<CourseCertificateClaimDatasource>(),
    ),
  );
  getIt.registerLazySingleton<CertificateFileActions>(
    () => CertificateFileActions(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CertificateInstagramStoryShare>(
    () => CertificateInstagramStoryShare(getIt<CertificateFileActions>()),
  );
  getIt.registerFactory<MyCertificatesBloc>(
    () => MyCertificatesBloc(getIt<MyCertificatesRepository>()),
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

  getIt.registerLazySingleton<StoreApiDatasource>(
    () => StoreApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<StoreDatasource>(
    () => getIt<StoreApiDatasource>(),
  );
  getIt.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(
      apiDatasource: getIt<StoreApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<StoreCatalogBloc>(
    () => StoreCatalogBloc(getIt<StoreRepository>()),
  );
  getIt.registerFactory<StoreDetailBloc>(
    () => StoreDetailBloc(getIt<StoreRepository>()),
  );
  getIt.registerFactory<StoreHistoryBloc>(
    () => StoreHistoryBloc(getIt<StoreRepository>()),
  );
  getIt.registerFactory<StoreOrderDetailBloc>(
    () => StoreOrderDetailBloc(getIt<StoreRepository>()),
  );

  getIt.registerLazySingleton<PortfolioApiDatasource>(
    () => PortfolioApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<PortfolioDatasource>(
    () => getIt<PortfolioApiDatasource>(),
  );
  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(
      apiDatasource: getIt<PortfolioApiDatasource>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<PortfolioBloc>(
    () => PortfolioBloc(getIt<PortfolioRepository>()),
  );
  getIt.registerFactory<PortfolioDetailBloc>(
    () => PortfolioDetailBloc(getIt<PortfolioRepository>()),
  );
  getIt.registerFactory<PortfolioCreateBloc>(
    () => PortfolioCreateBloc(getIt<PortfolioRepository>()),
  );
  getIt.registerFactory<PortfolioCommentsBloc>(
    () => PortfolioCommentsBloc(getIt<PortfolioRepository>()),
  );

  getIt.registerLazySingleton<AboutUsRepository>(() => AboutUsRepositoryImpl());
  getIt.registerFactory<AboutUsBloc>(
    () => AboutUsBloc(getIt<AboutUsRepository>()),
  );

  getIt.registerLazySingleton<PrivacyPolicyRepository>(
    () => PrivacyPolicyRepositoryImpl(),
  );
  getIt.registerFactory<PrivacyPolicyBloc>(
    () => PrivacyPolicyBloc(getIt<PrivacyPolicyRepository>()),
  );

  getIt.registerLazySingleton<DailyCoinApiDatasource>(
    () => DailyCoinApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<DailyCoinRepository>(
    () =>
        DailyCoinRepositoryImpl(apiDatasource: getIt<DailyCoinApiDatasource>()),
  );
  getIt.registerLazySingleton<DailyStreakDailyFetchService>(
    () => DailyStreakDailyFetchService(
      getIt<SharedPreferences>(),
      getIt<DailyCoinRepository>(),
      getIt<AuthSessionCubit>(),
    ),
  );
  getIt.registerFactory<DailyCoinBloc>(
    () => DailyCoinBloc(getIt<DailyCoinRepository>()),
  );

  getIt.registerLazySingleton<TasksApiDatasource>(
    () => TasksApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<TasksRemoteDatasource>(
    () => getIt<TasksApiDatasource>(),
  );
  getIt.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(remoteDatasource: getIt<TasksRemoteDatasource>()),
  );
  getIt.registerFactory<TasksBloc>(
    () => TasksBloc(
      getIt<TasksRepository>(),
      getIt<HomeRepository>(),
      getIt<DailyCoinRepository>(),
    ),
  );

  getIt.registerLazySingleton<MyActivityApiDatasource>(
    () => MyActivityApiDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MyActivityRepository>(
    () => MyActivityRepositoryImpl(
      apiDatasource: getIt<MyActivityApiDatasource>(),
    ),
  );
  getIt.registerFactory<MyActivityBloc>(
    () => MyActivityBloc(getIt<MyActivityRepository>()),
  );
}
