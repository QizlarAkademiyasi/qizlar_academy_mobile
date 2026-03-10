import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/config/settings/settings_data_source.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_mock_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/data/repository/home_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/bloc/home_bloc.dart';
import 'package:qizlar_academy_mobile/firebase_options.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppRemoteConfig.initialize();

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SettingsDataSource>(
    SettingsDataSourceImpl(prefs),
  );
  getIt.registerSingleton<AppOptionsService>(
    AppOptionsService(getIt<SettingsDataSource>()),
  );
  getIt.registerSingleton<GoRouter>(AppRoute.router);

  getIt.registerLazySingleton<HomeMockDatasource>(() => HomeMockDatasource());
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeMockDatasource>()),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<HomeRepository>()),
  );
}
