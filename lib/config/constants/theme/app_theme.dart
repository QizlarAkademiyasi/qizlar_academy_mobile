import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_color_scheme.dart';

/// Light va dark theme — design system color scheme asosida.
abstract class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    extensions: [AppColorScheme.light],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.darkColorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    extensions: [AppColorScheme.dark],
  );
}
