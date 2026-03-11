import 'package:flutter/material.dart';

/// Design system color palette — Figma: "Qizlar akademiyasi" / Colors node.
/// Light / Dark theme va opacity variantlari.
abstract class AppColors {
  AppColors._();

  // ─── Base / Shared ────────────────────────────────────────────────────────

  static const Color primary = Color(0xFFE8357D);
  static const Color grey = Color(0xFF64748B);
  static const Color secondaryGrey = Color(0xFF94A3B8);
  static const Color textDark = Color(0xFF0F172A);
  static const Color redAction = Color(0xFFEF4444);
  static const Color darkBackground = Color(0xFF0B0E13);
  static const Color bigOpacityDark = Color(0xFFB0B0B0);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF7F7F6);

  // ─── Light theme ─────────────────────────────────────────────────────────

  static const Color lightScaffold = white;
  static const Color lightNavBar = white;
  static const Color lightText = textDark;
  static const Color lightAction = white;
  static const Color lightStroke = Color(0xFFE2E8F0);
  static const Color lightOnContainer = white;
  static const Color lightOnSecondaryContainer = white;
  static const Color lightIconSecondary = Color(0xFFF8FAFC);

  // ─── Dark theme ──────────────────────────────────────────────────────────

  static const Color darkNavBar = Color(0xFF161C26);
  static const Color darkText = white;
  static const Color darkAction = Color(0xFF1E293B);
  static const Color darkStroke = Color(0xFF1E293B);
  static const Color darkOnContainer = black;
  static const Color darkOnSecondaryContainer = black;
  static const Color darkIconSecondary = textDark;

  // ─── Bottom bar (Liquid Glass) — Light / Dark ──────────────────────────────

  /// Light: shisha bar fon tint (glassColor).
  static final Color lightBottomBarGlass =
      lightNavBar.withValues(alpha: 0.6);

  /// Dark: shisha bar fon tint (glassColor).
  static final Color darkBottomBarGlass =
      darkNavBar.withValues(alpha: 0.6);

  /// Light: indikator pill (oddiy fallback, yopilishda).
  static final Color lightBottomBarIndicator =
      grey.withValues(alpha: 0.12);

  /// Dark: indikator pill (oddiy fallback).
  static final Color darkBottomBarIndicator =
      white.withValues(alpha: 0.08);

  /// Light: tanlanmagan tab icon/label.
  static const Color lightBottomBarTabUnselected = grey;

  /// Dark: tanlanmagan tab icon/label.
  static const Color darkBottomBarTabUnselected = secondaryGrey;

  // ─── Splash screen (light / dark) ─────────────────────────────────────────

  /// Light: bright pink background.
  static const Color splashLightBackground = primary;

  /// Dark: gradient start (qora).
  static const Color splashDarkBackgroundStart = Color(0xFF0D0A0C);

  /// Dark: gradient end (qorong'u binafsha).
  static const Color splashDarkBackgroundEnd = Color(0xFF1A1018);

  // ─── Others colors ───────────────────────────────────────────────────────

  static const Color otherRed = Color(0xFFF44336);
  static const Color otherPink = Color(0xFFE91E63);
  static const Color otherPurple = Color(0xFF9C27B0);
  static const Color otherDeepPurple = Color(0xFF673AB7);
  static const Color otherIndigo = Color(0xFF3F51B5);
  static const Color otherBlue = Color(0xFF2196F3);
  static const Color otherLightBlue = Color(0xFF03A9F4);
  static const Color otherCyan = Color(0xFF00BCD4);
  static const Color otherTeal = Color(0xFF009688);
  static const Color otherGreen = Color(0xFF4CAF50);
  static const Color otherLightGreen = Color(0xFF8BC34A);
  static const Color otherLime = Color(0xFFCDDC39);
  static const Color otherYellow = Color(0xFFFFEB3B);
  static const Color otherAmber = Color(0xFFFFC107);
  static const Color otherOrange = Color(0xFFFF9800);
  static const Color otherDeepOrange = Color(0xFFFF5722);
  static const Color otherBrown = Color(0xFF795548);
  static const Color otherBlueGrey = Color(0xFF607DB8);

  // ─── Opacity colors ───────────────────────────────────────────────────────

  static Color get whiteOpacity40 => white.withValues(alpha: 0.4);
  static Color get whiteOpacity20 => white.withValues(alpha: 0.2);
  static Color get whiteOpacity10 => white.withValues(alpha: 0.1);
  static Color get blackOpacity40 => black.withValues(alpha: 0.4);
  static Color get blackOpacity20 => black.withValues(alpha: 0.2);
  static Color get blackOpacity10 => black.withValues(alpha: 0.1);

  // ─── Flutter ColorScheme (Light) ─────────────────────────────────────────

  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: primary,
    onPrimary: lightAction,
    primaryContainer: primary,
    onPrimaryContainer: lightOnSecondaryContainer,
    secondary: grey,
    onSecondary: secondaryGrey,
    secondaryContainer: secondaryGrey,
    onSecondaryContainer: lightOnSecondaryContainer,
    tertiary: secondaryGrey,
    onTertiary: lightText,
    error: redAction,
    onError: lightAction,
    errorContainer: redAction,
    onErrorContainer: lightAction,
    surface: lightBackground,
    onSurface: lightText,
    surfaceContainerHighest: lightOnContainer,
    onSurfaceVariant: grey,
    outline: lightStroke,
    outlineVariant: lightStroke,
    shadow: black,
    scrim: black,
    inverseSurface: darkBackground,
    onInverseSurface: darkText,
    inversePrimary: primary,
    surfaceTint: primary,
  );

  // ─── Flutter ColorScheme (Dark) ──────────────────────────────────────────

  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: primary,
    onPrimary: darkAction,
    primaryContainer: primary,
    onPrimaryContainer: darkOnSecondaryContainer,
    secondary: grey,
    onSecondary: secondaryGrey,
    secondaryContainer: secondaryGrey,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: secondaryGrey,
    onTertiary: darkText,
    error: redAction,
    onError: darkAction,
    errorContainer: redAction,
    onErrorContainer: darkAction,
    surface: darkBackground,
    onSurface: darkText,
    surfaceContainerHighest: darkOnContainer,
    onSurfaceVariant: grey,
    outline: darkStroke,
    outlineVariant: darkStroke,
    shadow: black,
    scrim: black,
    inverseSurface: lightBackground,
    onInverseSurface: lightText,
    inversePrimary: primary,
    surfaceTint: primary,
  );
}
