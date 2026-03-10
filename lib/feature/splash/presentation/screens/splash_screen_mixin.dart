import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/components/splash_bottom_partners.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/components/splash_center_content.dart';

/// Splash ekrani uchun UI qismlarini qaytaruvchi mixin — Clean Architecture.
mixin SplashScreenMixin<T extends StatefulWidget> on State<T> {
  /// Markaziy kontent (logo).
  Widget buildCenterContent(BuildContext context) =>
      const SplashCenterContent();

  /// Pastki hamkor logolari.
  Widget buildBottomPartners(BuildContext context) =>
      const SplashBottomPartners();
}
