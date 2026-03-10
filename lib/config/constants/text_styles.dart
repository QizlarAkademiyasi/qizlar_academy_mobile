import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Plus Jakarta Sans — design system typography (rasmdagi typography tizimi).
TextStyle _plusJakarta(double fontSize, FontWeight weight) =>
    GoogleFonts.plusJakartaSans(fontSize: fontSize, fontWeight: weight);

class AppTextTheme {
  // --- Heading ---
  /// 72px, Bold
  final TextStyle heading1;

  /// 48px, Semibold
  final TextStyle heading2;

  /// 32px, Medium
  final TextStyle heading3;

  /// 24px, Regular
  final TextStyle heading4;

  /// 20px, Medium
  final TextStyle heading5;

  /// 16px, Bold
  final TextStyle heading6;

  // --- Body XLarge (18px) ---
  final TextStyle bodyXLargeBold;
  final TextStyle bodyXLargeSemibold;
  final TextStyle bodyXLargeMedium;
  final TextStyle bodyXLargeRegular;

  // --- Body Large (16px) ---
  final TextStyle bodyLargeBold;
  final TextStyle bodyLargeSemibold;
  final TextStyle bodyLargeMedium;
  final TextStyle bodyLargeRegular;

  // --- Body Medium (14px) ---
  final TextStyle bodyMediumBold;
  final TextStyle bodyMediumSemibold;
  final TextStyle bodyMediumMedium;
  final TextStyle bodyMediumRegular;

  // --- Body Small (12px) ---
  final TextStyle bodySmallBold;
  final TextStyle bodySmallSemibold;
  final TextStyle bodySmallMedium;
  final TextStyle bodySmallRegular;

  // --- Body XSmall (10px) ---
  final TextStyle bodyXSmallBold;
  final TextStyle bodyXSmallSemibold;
  final TextStyle bodyXSmallMedium;
  final TextStyle bodyXSmallRegular;

  AppTextTheme({
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    required this.heading5,
    required this.heading6,
    required this.bodyXLargeBold,
    required this.bodyXLargeSemibold,
    required this.bodyXLargeMedium,
    required this.bodyXLargeRegular,
    required this.bodyLargeBold,
    required this.bodyLargeSemibold,
    required this.bodyLargeMedium,
    required this.bodyLargeRegular,
    required this.bodyMediumBold,
    required this.bodyMediumSemibold,
    required this.bodyMediumMedium,
    required this.bodyMediumRegular,
    required this.bodySmallBold,
    required this.bodySmallSemibold,
    required this.bodySmallMedium,
    required this.bodySmallRegular,
    required this.bodyXSmallBold,
    required this.bodyXSmallSemibold,
    required this.bodyXSmallMedium,
    required this.bodyXSmallRegular,
  });

  static AppTextTheme of(BuildContext context) {
    return _AppThemeInheritedWidget.of(context).textTheme;
  }

  factory AppTextTheme.plusJakartaTheme() {
    return AppTextTheme(
      heading1: _plusJakarta(72, FontWeight.w700),
      heading2: _plusJakarta(48, FontWeight.w600),
      heading3: _plusJakarta(32, FontWeight.w500),
      heading4: _plusJakarta(24, FontWeight.w400),
      heading5: _plusJakarta(20, FontWeight.w500),
      heading6: _plusJakarta(16, FontWeight.w700),
      bodyXLargeBold: _plusJakarta(18, FontWeight.w700),
      bodyXLargeSemibold: _plusJakarta(18, FontWeight.w600),
      bodyXLargeMedium: _plusJakarta(18, FontWeight.w500),
      bodyXLargeRegular: _plusJakarta(18, FontWeight.w400),
      bodyLargeBold: _plusJakarta(16, FontWeight.w700),
      bodyLargeSemibold: _plusJakarta(16, FontWeight.w600),
      bodyLargeMedium: _plusJakarta(16, FontWeight.w500),
      bodyLargeRegular: _plusJakarta(16, FontWeight.w400),
      bodyMediumBold: _plusJakarta(14, FontWeight.w700),
      bodyMediumSemibold: _plusJakarta(14, FontWeight.w600),
      bodyMediumMedium: _plusJakarta(14, FontWeight.w500),
      bodyMediumRegular: _plusJakarta(14, FontWeight.w400),
      bodySmallBold: _plusJakarta(12, FontWeight.w700),
      bodySmallSemibold: _plusJakarta(12, FontWeight.w600),
      bodySmallMedium: _plusJakarta(12, FontWeight.w500),
      bodySmallRegular: _plusJakarta(12, FontWeight.w400),
      bodyXSmallBold: _plusJakarta(10, FontWeight.w700),
      bodyXSmallSemibold: _plusJakarta(10, FontWeight.w600),
      bodyXSmallMedium: _plusJakarta(10, FontWeight.w500),
      bodyXSmallRegular: _plusJakarta(10, FontWeight.w400),
    );
  }

  TextTheme get theme => TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineLarge: heading4,
    headlineMedium: heading5,
    headlineSmall: heading6,
    titleLarge: bodyLargeSemibold,
    titleMedium: bodyLargeRegular,
    titleSmall: bodyMediumRegular,
    labelLarge: bodyMediumSemibold,
    labelMedium: bodySmallSemibold,
    labelSmall: bodyXSmallRegular,
    bodyLarge: bodyLargeRegular,
    bodyMedium: bodyMediumRegular,
    bodySmall: bodySmallRegular,
  );

  Map<String, TextStyle> get htmlStyle => {
    'h1': heading1,
    'h2': heading2,
    'h3': heading3,
    'h4': heading4,
    'h5': heading5,
    'h6': heading6,
    'p': bodyLargeRegular,
  };
}

class _AppThemeInheritedWidget extends InheritedWidget {
  const _AppThemeInheritedWidget({
    required this.textTheme,
    required super.child,
  });

  final AppTextTheme textTheme;

  static _AppThemeInheritedWidget of(BuildContext context) {
    final _AppThemeInheritedWidget? result = context
        .dependOnInheritedWidgetOfExactType<_AppThemeInheritedWidget>();
    assert(result != null, 'No ChessThemeWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_AppThemeInheritedWidget old) {
    return old.textTheme != textTheme;
  }
}

class AppThemeProvider extends StatelessWidget {
  final WidgetBuilder builder;

  const AppThemeProvider({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return _AppThemeInheritedWidget(
      textTheme: AppTextTheme.plusJakartaTheme(),
      child: Builder(builder: builder),
    );
  }
}
