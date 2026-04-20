import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_coordinator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/splash/presentation/screens/splash_screen_mixin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin, SplashScreenMixin<SplashScreen> {
  static const _logoDuration = Duration(milliseconds: 880);
  static const _partnersDuration = Duration(milliseconds: 720);
  static const _partnersStartDelay = Duration(milliseconds: 340);

  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late AnimationController _partnersController;
  late Animation<double> _partnersOpacity;
  late Animation<Offset> _partnersSlide;

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
    _logoController = AnimationController(vsync: this, duration: _logoDuration);
    _logoScale = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _partnersController = AnimationController(vsync: this, duration: _partnersDuration);
    _partnersOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _partnersController, curve: Curves.easeOutCubic),
    );
    _partnersSlide = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero).animate(
      CurvedAnimation(parent: _partnersController, curve: Curves.easeOutCubic),
    );

    _runIntro();
  }

  Future<void> _runIntro() async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (!mounted) return;
    Gaimon.medium();
    unawaited(_logoController.forward());
    await Future<void>.delayed(_partnersStartDelay);
    if (!mounted) return;
    await _partnersController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _partnersController.dispose();
    super.dispose();
  }

  void _navigateAfterDelay() {
    unawaited(_bootstrapSplashExit());
  }

  Future<void> _bootstrapSplashExit() async {
    try {
      final cubit = getIt<AuthSessionCubit>();
      final deepLinks = getIt<AppDeepLinkCoordinator>();
      final delay = Future<void>.delayed(const Duration(milliseconds: 2600));
      final waitInitialLink = deepLinks.waitForInitialLinkResolved();
      if (cubit.state.isRegistered) {
        await Future.wait<void>([
          delay,
          waitInitialLink,
          cubit.ensureProfileGateResolved(),
        ]);
      } else {
        await Future.wait<void>([delay, waitInitialLink]);
      }
      if (!mounted) return;

      final deferred = deepLinks.consumeDeferredPushNavigation();
      if (deferred != null && deferred.isNotEmpty) {
        if (!mounted) return;
        if (AppDeepLinkCoordinator.isDetailPath(deferred)) {
          context.go(Routes.main);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.push(deferred);
          });
        } else {
          context.go(deferred);
        }
        return;
      }

      final session = cubit.state;
      if (!session.isRegistered) {
        context.go(Routes.main);
      } else if (session.needsProfileRegistration) {
        context.go(Routes.register);
      } else {
        context.go(Routes.main);
      }
    } catch (error, stackTrace) {
      AppLogger.e('splash_exit_error', error: error, stackTrace: stackTrace);
      if (!mounted) return;
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
            Positioned.fill(child: (isDark ? UiKitAssets.images.splashDark : UiKitAssets.images.splashLight).image(fit: BoxFit.cover)),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      alignment: Alignment.center,
                      child: buildCenterContent(context),
                    ),
                  ),
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _partnersOpacity,
                    child: SlideTransition(
                      position: _partnersSlide,
                      child: buildBottomPartners(context),
                    ),
                  ),
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
