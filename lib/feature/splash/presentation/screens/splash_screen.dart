import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/screens/splash_screen_mixin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, SplashScreenMixin<SplashScreen> {
  /// Zoom-in: logo o'rtadan chiqib keladi, bounce effect.
  static const _zoomInDuration = Duration(milliseconds: 1100);
  static const _zoomInCurve = Curves.elasticOut;

  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
    _zoomController = AnimationController(
      vsync: this,
      duration: _zoomInDuration,
    );
    _zoomAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _zoomController, curve: _zoomInCurve));
    _runIntro();
  }

  Future<void> _runIntro() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Gaimon.medium();
    _zoomController.forward();
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _navigateAfterDelay() {
    unawaited(_bootstrapSplashExit());
  }

  Future<void> _bootstrapSplashExit() async {
    final cubit = getIt<AuthSessionCubit>();
    final delay = Future<void>.delayed(const Duration(seconds: 2));
    if (cubit.state.isRegistered) {
      await Future.wait<void>([delay, cubit.ensureProfileGateResolved()]);
    } else {
      await delay;
    }
    if (!mounted) return;
    if (!cubit.state.isRegistered) {
      context.go(Routes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;

    // Rasmdagidek: ikkala rejimda ham status bar oq (vaqt, ikonkalar).
    const systemOverlay = SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlay,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child:
                  (isDark
                          ? UiKitAssets.images.splashDark
                          : UiKitAssets.images.splashLight)
                      .image(fit: BoxFit.cover),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  ScaleTransition(
                    scale: _zoomAnimation,
                    alignment: Alignment.center,
                    child: buildCenterContent(context),
                  ),
                  const Spacer(flex: 2),
                  buildBottomPartners(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
