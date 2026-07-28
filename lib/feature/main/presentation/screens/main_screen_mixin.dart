import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_one.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_two.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_profile_tab_icon.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

/// Main shell ekrani uchun tab tanlashi va pastki bar qismini qaytaruvchi mixin.
mixin MainScreenMixin<T extends StatefulWidget> on State<T> {
  bool get isGuestMode;

  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;

  /// Pastki bar orqali tab almashganda oshadi — [MainScreen] fade faqat shu bilan ishlaydi.
  int get tabBarFadeNonce => _tabBarFadeNonce;
  int _tabBarFadeNonce = 0;

  bool get isExtraMenuExpanded => _isExtraMenuExpanded;
  bool _isExtraMenuExpanded = false;

  MainExtraMenuItem? get selectedExtraMenuItem => _selectedExtraMenuItem;
  MainExtraMenuItem? _selectedExtraMenuItem;

  bool get isBottomNavMinimized => _isBottomNavMinimized;
  bool _isBottomNavMinimized = false;
  double _bottomNavScrollDelta = 0;

  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onTabTap(int index) {
    _setBottomNavMinimized(false);

    if (index == kMainProfileTabIndex &&
        _selectedIndex != kMainProfileTabIndex) {
      toggleExtraMenu();
      return;
    }

    if (index == kMainProfileTabIndex && isGuestMode) {
      context.go(Routes.signIn);
      return;
    }

    if (index == kMainProfileTabIndex) {
      toggleExtraMenu();
      return;
    }

    if (_isExtraMenuExpanded) {
      setState(() => _isExtraMenuExpanded = false);
    }
    _handleTabTap(index);
  }

  void toggleExtraMenu() {
    setState(() {
      _isBottomNavMinimized = false;
      _bottomNavScrollDelta = 0;
      _isExtraMenuExpanded = !_isExtraMenuExpanded;
    });
  }

  void closeExtraMenu() {
    if (_isExtraMenuExpanded) {
      setState(() => _isExtraMenuExpanded = false);
    }
  }

  void onPortfolioTap() {
    closeExtraMenu();
    context.push(Routes.portfolio);
  }

  void onExtraMenuItemTap(MainExtraMenuItem item) {
    setState(() {
      _isExtraMenuExpanded = false;
      if (item is! MainExtraActionMenuItem) {
        _selectedExtraMenuItem = item;
      }
    });
    switch (item) {
      case MainExtraTabMenuItem(:final tabIndex):
        _handleTabTap(tabIndex);
      case MainExtraRouteMenuItem(:final screenRoute):
        context.push(screenRoute);
      case MainExtraActionMenuItem(:final action):
        _handleExtraMenuAction(action);
    }
  }

  void _handleExtraMenuAction(MainExtraMenuAction action) {
    switch (action) {
      case MainExtraMenuAction.joinTeam:
        break;
    }
  }

  void _handleTabTap(int index) {
    // Gaimon.light();
    if (isGuestMode && (index == 1 || index == kMainProfileTabIndex)) {
      context.go(Routes.signIn);
      return;
    }

    if (_selectedIndex == index) return;

    setState(() {
      _tabBarFadeNonce++;
      _selectedIndex = index;
    });
  }

  void onPageChanged(int index) {
    Gaimon.light();
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _isExtraMenuExpanded = false;
        _isBottomNavMinimized = false;
        _bottomNavScrollDelta = 0;
        if (index == kMainProfileTabIndex) {
          _selectedExtraMenuItem = kMainExtraTabMenuItems.single;
        }
      });
    }
  }

  /// Aktiv tab ichidagi vertikal scrollni kuzatib, pastki navigatsiyani
  /// scroll-down'da ixchamlaydi va scroll-up'da qayta ochadi.
  bool onMainScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    if (_isExtraMenuExpanded) {
      _bottomNavScrollDelta = 0;
      _setBottomNavMinimized(false);
      return false;
    }

    if (notification.metrics.pixels <= 4) {
      _bottomNavScrollDelta = 0;
      _setBottomNavMinimized(false);
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta == 0) return false;

      if ((_bottomNavScrollDelta > 0 && delta < 0) ||
          (_bottomNavScrollDelta < 0 && delta > 0)) {
        _bottomNavScrollDelta = 0;
      }
      _bottomNavScrollDelta += delta;

      if (_bottomNavScrollDelta >= 22) {
        _bottomNavScrollDelta = 0;
        _setBottomNavMinimized(true);
      } else if (_bottomNavScrollDelta <= -14) {
        _bottomNavScrollDelta = 0;
        _setBottomNavMinimized(false);
      }
    } else if (notification is ScrollEndNotification) {
      _bottomNavScrollDelta = 0;
    }

    return false;
  }

  void _setBottomNavMinimized(bool value) {
    if (_isBottomNavMinimized == value || !mounted) return;
    setState(() => _isBottomNavMinimized = value);
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final barTheme = theme.bottomNavigationBarTheme;
    final selectedColor =
        barTheme.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor =
        barTheme.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.64);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTap,
        items: [
          BottomNavigationBarItem(
            icon: MainBottomNavKitIcons.home(unselectedColor, 24, false),
            activeIcon: MainBottomNavKitIcons.home(selectedColor, 24, true),
            label: context.l10n.mainTabHome,
          ),
          BottomNavigationBarItem(
            icon: MainBottomNavKitIcons.courses(unselectedColor, 24, false),
            activeIcon: MainBottomNavKitIcons.courses(selectedColor, 24, true),
            label: context.l10n.mainTabCourses,
          ),
          BottomNavigationBarItem(
            icon: MainBottomNavKitIcons.leaderboard(unselectedColor, 24, false),
            activeIcon: MainBottomNavKitIcons.leaderboard(
              selectedColor,
              24,
              true,
            ),
            label: context.l10n.mainTabLeaderboard,
          ),
          BottomNavigationBarItem(
            icon: MainBottomNavProfileTabIcon(
              isGuestMode: isGuestMode,
              selected: false,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            activeIcon: MainBottomNavProfileTabIcon(
              isGuestMode: isGuestMode,
              selected: true,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            label: context.l10n.mainTabProfile,
          ),
        ],
      ),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    const selectedColor = AppColors.white;
    final unselectedColor = AppColors.white.withValues(alpha: 0.65);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTabTap,
      destinations: [
        NavigationDestination(
          icon: MainBottomNavKitIcons.home(unselectedColor, 24, false),
          selectedIcon: MainBottomNavKitIcons.home(selectedColor, 24, true),
          label: context.l10n.mainTabHome,
        ),
        NavigationDestination(
          icon: MainBottomNavKitIcons.courses(unselectedColor, 24, false),
          selectedIcon: MainBottomNavKitIcons.courses(selectedColor, 24, true),
          label: context.l10n.mainTabCourses,
        ),
        NavigationDestination(
          icon: MainBottomNavKitIcons.leaderboard(unselectedColor, 24, false),
          selectedIcon: MainBottomNavKitIcons.leaderboard(
            selectedColor,
            24,
            true,
          ),
          label: context.l10n.mainTabLeaderboard,
        ),
        NavigationDestination(
          icon: MainBottomNavProfileTabIcon(
            isGuestMode: isGuestMode,
            selected: false,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          selectedIcon: MainBottomNavProfileTabIcon(
            isGuestMode: isGuestMode,
            selected: true,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
          ),
          label: context.l10n.mainTabProfile,
        ),
      ],
    );
  }

  Widget buildGlassBottomBarVersionOne(BuildContext context) {
    return GlassBottomNavigationVersionOne(
      currentIndex: _selectedIndex,
      onTap: onTabTap,
      fake: false,
    );
  }

  Widget buildGlassBottomBarVersionTwo(BuildContext context) {
    return GlassBottomNavigationVersionTwo(
      currentIndex: _selectedIndex,
      onTap: onTabTap,
    );
  }
}
