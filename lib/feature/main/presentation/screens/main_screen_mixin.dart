import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/watchdog/watchdog_screen_tracker.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_one.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_two.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_profile_tab_icon.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

/// Main shell ekrani uchun tab tanlashi va pastki bar qismini qaytaruvchi mixin.
mixin MainScreenMixin<T extends StatefulWidget> on State<T> {
  bool get isGuestMode;

  /// Pastki bar pill/ikon tanlovi — tab kontenti almashishidan oldin yangilanadi.
  final ValueNotifier<int> navIndex = ValueNotifier(0);

  /// Asosiy tab stack indeksi — keyingi frame’da yangilanadi (CrossFade uchun).
  final ValueNotifier<int> tabIndex = ValueNotifier(0);

  int get selectedIndex => tabIndex.value;

  int get bottomNavigationSelectedIndex => navIndex.value;

  bool get isServicesHubTabActive =>
      !isGuestMode && tabIndex.value == kMainServicesHubTabIndex;

  /// Pastki bar orqali tab almashganda oshadi — [MainTabStack] CrossFade faqat shu bilan.
  int get tabBarFadeNonce => _tabBarFadeNonce;
  int _tabBarFadeNonce = 0;

  void disposeMainTabSelection() {
    navIndex.dispose();
    tabIndex.dispose();
  }

  void onTabTap(int index) {
    if (isGuestMode && index == kMainProfileTabIndex) {
      context.go(Routes.signIn);
      return;
    }
    _handleTabTap(index);
  }

  void onServicesHubTap() {
    if (isGuestMode) {
      context.go(Routes.signIn);
      return;
    }
    _handleTabTap(kMainServicesHubTabIndex);
  }

  void openAiChat() {
    context.push(Routes.aiChat);
  }

  void _scheduleTabIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (tabIndex.value == index) return;
      tabIndex.value = index;
      setState(() => _tabBarFadeNonce++);
    });
  }

  void _handleTabTap(int index) {
    if (index == kMainServicesHubTabIndex) {
      if (tabIndex.value == kMainServicesHubTabIndex) {
        return;
      }
      _scheduleTabIndex(kMainServicesHubTabIndex);
      Gaimon.light();
      reportWatchdogMainTab(
        kMainServicesHubTabIndex,
        isGuestMode: false,
        path: Routes.mainUser,
      );
      return;
    }

    if (tabIndex.value == index && navIndex.value == index) {
      return;
    }

    navIndex.value = index;
    if (tabIndex.value != index) {
      _scheduleTabIndex(index);
    }
    Gaimon.light();
    reportWatchdogMainTab(
      index,
      isGuestMode: isGuestMode,
      path: isGuestMode ? Routes.mainGuest : Routes.mainUser,
    );
  }

  /// Scroll paytida pastki navigatsiyani kichraytirish o‘chirilgan.
  bool onMainScrollNotification(ScrollNotification notification) {
    return false;
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
        currentIndex: bottomNavigationSelectedIndex,
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
      selectedIndex: bottomNavigationSelectedIndex,
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
      currentIndex: navIndex.value,
      onTap: onTabTap,
      fake: false,
    );
  }

  Widget buildGlassBottomBarVersionTwo(BuildContext context) {
    return GlassBottomNavigationVersionTwo(
      currentIndex: navIndex.value,
      onTap: onTabTap,
    );
  }
}
