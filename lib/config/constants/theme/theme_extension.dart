import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_color_scheme.dart';

/// Theme va colorScheme ga BuildContext orqali kirish.
///
/// Asosiy foydalanish:
/// - `context.appColors.primary` — Figma semantic token
/// - `context.textTheme.heading5` — tipografiya
/// - `context.colorScheme.onSurface` — Flutter standart (fallback)
extension ThemeExtension on BuildContext {
  AppTextTheme get textTheme => AppTextTheme.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkTheme => theme.brightness == Brightness.dark;
  bool get isLightTheme => theme.brightness == Brightness.light;

  /// Figma design tokenlariga to'g'ridan-to'g'ri kirish.
  /// ```dart
  /// context.appColors.stroke
  /// context.appColors.navBar
  /// context.appColors.bigOpacity
  /// ```
  AppColorScheme get appColors =>
      theme.extension<AppColorScheme>() ??
      (isDarkTheme ? AppColorScheme.dark : AppColorScheme.light);
}
