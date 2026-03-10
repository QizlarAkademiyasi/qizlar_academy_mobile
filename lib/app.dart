import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appOptionsService = getIt<AppOptionsService>();
    final appOptions = appOptionsService.createAppOptions();
    final goRouter = getIt<GoRouter>();

    return ModelBinding(
      initialModel: appOptions,
      builder: (context) => MaterialApp.router(
        routerConfig: goRouter,
        title: 'Qizlar Akademiyasi',
        theme: AppOptions.of(context).themeLightData(context),
        darkTheme: AppOptions.of(context).themeDarkData(context),
        themeMode: AppOptions.of(context).themeMode,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
