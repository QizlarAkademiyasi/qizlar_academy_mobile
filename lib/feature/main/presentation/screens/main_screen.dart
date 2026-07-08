import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/app_update/app_update_prompt_coordinator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_action_grid.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
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
            // _KeepAlivePage(
            //   child: MainMoreTabPage(selectedItemIndex: morePanelSelectedItemIndex, onItemSelected: onMorePanelItemSelected),
            // ),
          ]
        : <Widget>[
            _KeepAlivePage(child: HomeScreen(onSwitchMainTab: onTabTap)),
            const _KeepAlivePage(child: CoursesScreen()),
            const _KeepAlivePage(child: LeaderboardScreen()),
            const _KeepAlivePage(child: ProfileScreen()),
            // _KeepAlivePage(
            //   child: MainMoreTabPage(selectedItemIndex: morePanelSelectedItemIndex, onItemSelected: onMorePanelItemSelected),
            // ),
          ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: _MainTabPageViewWithFade(pageController: pageController, selectedIndex: selectedIndex, tabBarFadeNonce: tabBarFadeNonce, onPageChanged: onPageChanged, pages: pages),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: MediaQuery.of(context).padding.bottom,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //         colors: [
          //           (context.isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground),
          //           (context.isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.6),
          //           (context.isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.0),
          //         ],
          //         stops: [0, 0.5, 1],
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 100,
          //     width: double.infinity,
          //     decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 32, color: AppColors.shadow.withValues(alpha: 0.14))]),
          //   ),
          // ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: isExtraMenuExpanded ? 1 : 0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: !isExtraMenuExpanded,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: closeExtraMenu,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: context.isDarkTheme ? UiKitAssets.images.bottomNavDark.image() : UiKitAssets.images.bottomNavLight.image()),
          Align(
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(offset: Offset(0, 5), spreadRadius: -10, blurRadius: 30, color: AppColors.shadow.withValues(alpha: .2))],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: SecondLiquidBottomNav(
                  items: mainAppSecondLiquidBottomNavItems(context, isGuestMode: isGuestMode),
                  currentIndex: selectedIndex,
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  onChanged: onTabTap,
                  selectedColor: context.appColors.primary,
                  unselectedColor: context.appColors.bottomBarTabUnselected,
                  extraActionIcon: Icons.add,
                  onExtraActionTap: toggleExtraMenu,
                  extraActionSemanticLabel: context.l10n.mainTabMore,
                  isExpanded: isExtraMenuExpanded,
                  expandedContent: MainExtraActionGrid(onItemTap: onExtraMenuItemTap),
                  expandedContentHeight: MainExtraActionGrid.preferredHeightFor(kMainExtraMenuItems.length),
                ),
              ),
            ),
          ),
          // if (Platform.isIOS)
          //   Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: Container(
          //       decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 32, color: AppColors.shadow.withValues(alpha: 0.14))]),
          //       child: buildGlassBottomBarVersionOne(context),
          //     ),
          //   ),
        ],
      ),
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
