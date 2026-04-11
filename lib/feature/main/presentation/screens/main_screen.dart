import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/app_update/app_update_prompt_coordinator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/profile_screen.dart';

import '../../../home/presentation/screens/home_screen_main.dart' show HomeScreen;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.isGuestMode});

  final bool isGuestMode;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with MainScreenMixin<MainScreen>, WidgetsBindingObserver {
  @override
  bool get isGuestMode => widget.isGuestMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(AppUpdatePromptCoordinator.checkAndShowIfNeeded(context));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(AppUpdatePromptCoordinator.checkAndShowIfNeeded(context));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.isGuestMode
        ? <Widget>[
            _KeepAlivePage(child: HomeScreen(onSwitchMainTab: onTabTap)),
            const _KeepAlivePage(child: CoursesScreen()),
            const _KeepAlivePage(child: LeaderboardScreen()),
            const _KeepAlivePage(child: _GuestProfileRedirectView()),
          ]
        : <Widget>[
            _KeepAlivePage(child: HomeScreen(onSwitchMainTab: onTabTap)),
            const _KeepAlivePage(child: CoursesScreen()),
            const _KeepAlivePage(child: LeaderboardScreen()),
            const _KeepAlivePage(child: ProfileScreen()),
          ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: _MainTabPageViewWithFade(pageController: pageController, selectedIndex: selectedIndex, tabBarFadeNonce: tabBarFadeNonce, onPageChanged: onPageChanged, pages: pages),
          ),
          // if (Platform.isIOS)
          //   Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: Container(
          //       decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 32, color: AppColors.shadow.withValues(alpha: 0.14))]),
          //       child: buildGlassBottomBarVersionTwo(context),
          //     ),
          //   ),
        ],
      ),
      bottomNavigationBar: buildNavigationBar(context),
    );
  }
}

/// [PageView] scroll/swipe — fade yo‘q; pastki bar — fade + `jumpToPage`.
class _MainTabPageViewWithFade extends StatefulWidget {
  const _MainTabPageViewWithFade({required this.pageController, required this.selectedIndex, required this.tabBarFadeNonce, required this.onPageChanged, required this.pages});

  final PageController pageController;
  final int selectedIndex;

  /// [MainScreenMixin] `_handleTabTap` da har safar oshiriladi.
  final int tabBarFadeNonce;
  final ValueChanged<int> onPageChanged;
  final List<Widget> pages;

  @override
  State<_MainTabPageViewWithFade> createState() => _MainTabPageViewWithFadeState();
}

class _MainTabPageViewWithFadeState extends State<_MainTabPageViewWithFade> with SingleTickerProviderStateMixin {
  static const Duration _halfFade = Duration(milliseconds: 160);

  late final AnimationController _fadeController = AnimationController(vsync: this, duration: _halfFade);
  late final Animation<double> _opacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

  int _fadeToken = 0;

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _MainTabPageViewWithFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    final indexChanged = widget.selectedIndex != oldWidget.selectedIndex;
    final barDroveChange = widget.tabBarFadeNonce != oldWidget.tabBarFadeNonce;
    if (indexChanged && barDroveChange) {
      unawaited(_runTabSwitchFade(++_fadeToken));
    }
  }

  Future<void> _runTabSwitchFade(int token) async {
    _fadeController.stop();
    _fadeController.value = 0;

    await _fadeController.forward();
    if (!mounted || token != _fadeToken) {
      if (mounted) _fadeController.value = 0;
      return;
    }

    widget.pageController.jumpToPage(widget.selectedIndex);

    await _fadeController.reverse();
    if (!mounted || token != _fadeToken) {
      if (mounted) _fadeController.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: PageView(physics: ClampingScrollPhysics(), controller: widget.pageController, onPageChanged: widget.onPageChanged, children: widget.pages),
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage> with AutomaticKeepAliveClientMixin<_KeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _GuestProfileRedirectView extends StatelessWidget {
  const _GuestProfileRedirectView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton.elevated(label: context.l10n.guestSignInCta, onPressed: () => context.go(Routes.signIn)),
    );
  }
}
