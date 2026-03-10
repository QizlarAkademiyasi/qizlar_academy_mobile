import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';

/// Figma "Colors" nodiga to'g'ridan-to'g'ri mos keladigan semantic token'lar.
///
/// Foydalanish:
/// ```dart
/// context.appColors.primary
/// context.appColors.stroke
/// context.appColors.navBar
/// ```
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.primary,
    required this.background,
    required this.navBar,
    required this.text,
    required this.grey,
    required this.secondaryGrey,
    required this.action,
    required this.stroke,
    required this.onContainer,
    required this.bigOpacity,
    required this.onSecondaryContainer,
    required this.iconSecondary,
    required this.error,
  });

  final Color primary;

  /// Karta va sahifa foni (surface).
  final Color background;

  /// Navigation bar foni.
  final Color navBar;

  /// Asosiy matn rangi.
  final Color text;

  /// Ikkinchi darajali grey (icon, subtitle).
  final Color grey;

  /// Uchinchi darajali grey (placeholder, hint).
  final Color secondaryGrey;

  /// Interaktiv element (button bg, tappable surface).
  final Color action;

  /// Border / Divider rangi.
  final Color stroke;

  /// Container ichidagi element rangi.
  final Color onContainer;

  /// Katta opacity overlay (modal bg va h.k.).
  final Color bigOpacity;

  /// Secondary container ichidagi element.
  final Color onSecondaryContainer;

  /// Icon secondary rangi.
  final Color iconSecondary;

  /// Xato holati rangi.
  final Color error;

  // ─── Light ───────────────────────────────────────────────────────────────

  static final AppColorScheme light = AppColorScheme(
    primary: AppColors.primary,
    background: AppColors.lightBackground,
    navBar: AppColors.lightNavBar,
    text: AppColors.lightText,
    grey: AppColors.grey,
    secondaryGrey: AppColors.secondaryGrey,
    action: AppColors.lightAction,
    stroke: AppColors.lightStroke,
    onContainer: AppColors.lightOnContainer,
    bigOpacity: AppColors.whiteOpacity40,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,
    iconSecondary: AppColors.lightIconSecondary,
    error: AppColors.redAction,
  );

  // ─── Dark ────────────────────────────────────────────────────────────────

  static final AppColorScheme dark = AppColorScheme(
    primary: AppColors.primary,
    background: AppColors.darkBackground,
    navBar: AppColors.darkNavBar,
    text: AppColors.darkText,
    grey: AppColors.grey,
    secondaryGrey: AppColors.secondaryGrey,
    action: AppColors.darkAction,
    stroke: AppColors.darkStroke,
    onContainer: AppColors.darkOnContainer,
    bigOpacity: AppColors.bigOpacityDark,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    iconSecondary: AppColors.darkIconSecondary,
    error: AppColors.redAction,
  );

  // ─── ThemeExtension impl ──────────────────────────────────────────────────

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? background,
    Color? navBar,
    Color? text,
    Color? grey,
    Color? secondaryGrey,
    Color? action,
    Color? stroke,
    Color? onContainer,
    Color? bigOpacity,
    Color? onSecondaryContainer,
    Color? iconSecondary,
    Color? error,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      navBar: navBar ?? this.navBar,
      text: text ?? this.text,
      grey: grey ?? this.grey,
      secondaryGrey: secondaryGrey ?? this.secondaryGrey,
      action: action ?? this.action,
      stroke: stroke ?? this.stroke,
      onContainer: onContainer ?? this.onContainer,
      bigOpacity: bigOpacity ?? this.bigOpacity,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      error: error ?? this.error,
    );
  }

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      text: Color.lerp(text, other.text, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      secondaryGrey: Color.lerp(secondaryGrey, other.secondaryGrey, t)!,
      action: Color.lerp(action, other.action, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      onContainer: Color.lerp(onContainer, other.onContainer, t)!,
      bigOpacity: Color.lerp(bigOpacity, other.bigOpacity, t)!,
      onSecondaryContainer: Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
