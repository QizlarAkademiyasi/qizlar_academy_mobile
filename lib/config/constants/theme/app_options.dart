import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/settings/settings_data_source.dart';

typedef ThemeDataBuilder = ThemeData Function(BuildContext context);

class AppOptions extends Equatable {
  const AppOptions(this._settingsDataSource, {required this.locale, required this.themeMode, required this.themeLightData, required this.themeDarkData});

  factory AppOptions.fromSettings(SettingsDataSource settingsDataSource) {
    return AppOptions(
      settingsDataSource,
      locale: settingsDataSource.getLocale(),
      themeMode: settingsDataSource.getThemeMode(),
      themeLightData: AppOptions.lightThemeData,
      themeDarkData: AppOptions.darkThemeData,
    );
  }

  final SettingsDataSource _settingsDataSource;
  final Locale locale;
  final ThemeMode themeMode;
  final ThemeDataBuilder themeLightData;
  final ThemeDataBuilder themeDarkData;

  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
      case ThemeMode.dark:
        brightness = Brightness.dark;
      case ThemeMode.system:
        brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
    return brightness == Brightness.dark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
  }

  AppOptions copyWith({Locale? locale, ThemeMode? themeMode, ThemeDataBuilder? themeLightData, ThemeDataBuilder? themeDarkData}) => AppOptions(
    _settingsDataSource,
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
    themeLightData: themeLightData ?? this.themeLightData,
    themeDarkData: themeDarkData ?? this.themeDarkData,
  );

  static AppOptions of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    return scope.modelBindingState.currentModel;
  }

  static void update(BuildContext context, AppOptions newModel) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    scope.modelBindingState.updateModel(newModel);
  }

  static ThemeData darkThemeData(BuildContext context) {
    final base = ThemeData(useMaterial3: true, colorScheme: AppColors.darkColorScheme, brightness: Brightness.dark);
    final textTheme = context.textTheme.theme;
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: textTheme,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        indicatorColor: AppColors.primary,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(AppColors.darkBackground), surfaceTintColor: WidgetStateProperty.all(AppColors.darkBackground)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
    );
  }

  static ThemeData lightThemeData(BuildContext context) {
    final base = ThemeData(useMaterial3: true, colorScheme: AppColors.lightColorScheme, brightness: Brightness.light);
    final textTheme = context.textTheme.theme;
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: textTheme,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.primary),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightBackground, surfaceTintColor: Colors.transparent),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightBackground,
        indicatorColor: AppColors.primary,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      tabBarTheme: TabBarThemeData(indicatorSize: TabBarIndicatorSize.tab, dividerColor: Colors.transparent, labelColor: AppColors.white, unselectedLabelColor: AppColors.lightText),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: const InputDecorationTheme(fillColor: AppColors.black),
        menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(AppColors.primary), surfaceTintColor: WidgetStateProperty.all(AppColors.primary)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
    );
  }

  @override
  List<Object> get props => [locale, themeMode, themeLightData, themeDarkData];
}

class _ModelBindingScope extends InheritedWidget {
  const _ModelBindingScope({required this.modelBindingState, required super.child});

  final _ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

class ModelBinding extends StatefulWidget {
  const ModelBinding({super.key, required this.initialModel, required this.builder});

  final AppOptions initialModel;
  final WidgetBuilder builder;

  @override
  State<ModelBinding> createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ModelBinding> {
  late AppOptions currentModel;
  StreamSubscription<ThemeMode>? _themeModeSubscription;
  StreamSubscription<Locale>? _localeSubscription;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
    _setupListeners();
  }

  void _setupListeners() {
    _themeModeSubscription = currentModel._settingsDataSource.themeModeStream.listen((themeMode) {
      if (themeMode != currentModel.themeMode) {
        setState(() {
          currentModel = currentModel.copyWith(themeMode: themeMode);
        });
      }
    });
    _localeSubscription = currentModel._settingsDataSource.localeStream.listen((locale) {
      if (locale != currentModel.locale) {
        setState(() {
          currentModel = currentModel.copyWith(locale: locale);
        });
      }
    });
  }

  Future<void> updateModel(AppOptions newModel) async {
    if (newModel != currentModel) {
      final hadLocaleChange = newModel.locale != currentModel.locale;
      final hadThemeChange = newModel.themeMode != currentModel.themeMode;
      setState(() {
        currentModel = newModel;
      });
      if (hadLocaleChange) {
        await newModel._settingsDataSource.setLocale(newModel.locale);
      }
      if (hadThemeChange) {
        await newModel._settingsDataSource.setThemeMode(newModel.themeMode);
      }
    }
  }

  @override
  void dispose() {
    _themeModeSubscription?.cancel();
    _localeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ModelBindingScope(
    modelBindingState: this,
    child: AppThemeProvider(builder: widget.builder),
  );
}

class AppOptionsService {
  final SettingsDataSource _settingsDataSource;

  const AppOptionsService(this._settingsDataSource);

  AppOptions createAppOptions() {
    return AppOptions.fromSettings(_settingsDataSource);
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _settingsDataSource.setThemeMode(themeMode);
  }

  Future<void> updateLocale(Locale locale) async {
    await _settingsDataSource.setLocale(locale);
  }

  Future<void> clearLocale() async {
    await _settingsDataSource.clearLocale();
  }

  Locale get currentLocale => _settingsDataSource.getLocale();

  ThemeMode get currentThemeMode => _settingsDataSource.getThemeMode();

  Stream<ThemeMode> get themeModeStream => _settingsDataSource.themeModeStream;

  Stream<Locale> get localeStream => _settingsDataSource.localeStream;
}
