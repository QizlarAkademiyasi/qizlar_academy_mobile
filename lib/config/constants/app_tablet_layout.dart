import 'package:flutter/widgets.dart';

/// Planshet (iPad va hokazo) layout uchun yordamchi qiymatlar.
///
/// Tablet aniqlash: Flutter HIG bilan mos — qisqa tomon ≥ 600 logical point.
abstract class AppTabletLayout {
  AppTabletLayout._();

  /// iPhone 17 Pro Max portrait logical width (points), 440 × 956.
  static const double contentMaxWidthPoints = 440;

  /// Planshetda modal dialog — kontentdan kengroq, lekin butun ekranni egallamaydi.
  static const double modalMaxWidthPoints = 440;

  /// [MediaQuery.sizeOf] bo‘yicha planshet deb hisoblash chegarasi.
  static const double tabletShortestSideBreakpoint = 600;

  static bool isTabletSized(Size size) => size.shortestSide >= tabletShortestSideBreakpoint;
}
