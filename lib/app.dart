import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/network/activity_ping_service.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/router_boot_placeholder.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appOptionsService = getIt<AppOptionsService>();
    final appOptions = appOptionsService.createAppOptions();
    final goRouter = getIt<GoRouter>();

    return ModelBinding(
      initialModel: appOptions,
      builder: (context) => ActivityPingScope(
        child: MaterialApp.router(
          routerConfig: goRouter,
          builder: (context, child) => _GlobalKeyboardDismiss(child: ThemeCircleAnimation(child: child ?? const RouterBootPlaceholder())),
          onGenerateTitle: (ctx) => ctx.l10n.appTitle,
          scrollBehavior: ScrollBehavior().copyWith(physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())),
          theme: AppOptions.of(context).themeLightData(context),
          darkTheme: AppOptions.of(context).themeDarkData(context),
          themeMode: AppOptions.of(context).themeMode,
          locale: AppOptions.of(context).locale,
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
        ),
      ),
    );
  }
}

class _GlobalKeyboardDismiss extends StatelessWidget {
  const _GlobalKeyboardDismiss({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus == null) return;
        currentFocus.unfocus();
      },
      child: child,
    );
  }
}
