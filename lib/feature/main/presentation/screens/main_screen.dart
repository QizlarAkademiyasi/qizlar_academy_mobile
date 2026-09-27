import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/app_update/app_update_prompt_coordinator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/announcement/presentation/services/announcement_session_coordinator.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_ai_chat_floating_pill.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_drag_hide_area.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_tab_stack.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/profile_screen.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/services_hub_main_tab_page.dart';

import '../../../home/presentation/screens/home_screen_main.dart'
    show HomeScreen;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.isGuestMode});

  final bool isGuestMode;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with MainScreenMixin<MainScreen>, WidgetsBindingObserver {
  late final AnnouncementSessionCoordinator _announcementCoordinator;

  @override
  bool get isGuestMode => widget.isGuestMode;

  @override
  void initState() {
    super.initState();
    _announcementCoordinator = getIt<AnnouncementSessionCoordinator>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(AppUpdatePromptCoordinator.checkAndShowIfNeeded(context));
      if (!widget.isGuestMode) {
        _announcementCoordinator.start(context);
      }
    });
  }

  @override
  void dispose() {
    disposeMainTabSelection();
    _announcementCoordinator.stop();
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
      return;
    }
    _announcementCoordinator.stop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationOffset = switch (Theme.of(context).platform) {
      TargetPlatform.android => const Offset(0, 6),
      TargetPlatform.iOS => const Offset(0, 18),
      _ => Offset.zero,
    };
    final pages = widget.isGuestMode
        ? <Widget>[
            HomeScreen(onSwitchMainTab: onTabTap),
            const CoursesScreen(
              key: ValueKey('main-tab-courses'),
              bottomContentInset: 72,
              showBackButton: false,
            ),
            const LeaderboardScreen(),
            const _GuestSignInRedirectView(),
          ]
        : <Widget>[
            HomeScreen(onSwitchMainTab: onTabTap),
            const CoursesScreen(
              key: ValueKey('main-tab-courses'),
              bottomContentInset: 72,
              showBackButton: false,
            ),
            const LeaderboardScreen(),
            const ProfileScreen(key: ValueKey('main-tab-profile')),
            const ServicesHubMainTabPage(bottomContentInset: 120),
          ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          (context.isDarkTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: NotificationListener<ScrollNotification>(
                onNotification: onMainScrollNotification,
                child: ValueListenableBuilder<int>(
                  valueListenable: tabIndex,
                  builder: (context, stackIndex, _) {
                    return MainTabStack(
                      selectedIndex: stackIndex,
                      fadeNonce: tabBarFadeNonce,
                      pages: pages,
                    );
                  },
                ),
              ),
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
            MainBottomNavDragHideArea(
              navigationOffset: bottomNavigationOffset,
              onDismissIntent: (_) => tryPopAppModalSheet(context),
              floatingPill: MainAiChatFloatingPillOverlay(
                bottomNavigationOffset: bottomNavigationOffset,
                onTap: openAiChat,
              ),
              navigation: RepaintBoundary(
                child: ValueListenableBuilder<int>(
                  valueListenable: navIndex,
                  builder: (context, navSelectedIndex, _) {
                    return ValueListenableBuilder<int>(
                      valueListenable: tabIndex,
                      builder: (context, stackIndex, _) {
                        final hubActive = !isGuestMode &&
                            stackIndex == kMainServicesHubTabIndex;
                        return SecondLiquidBottomNav(
                          items: mainAppSecondLiquidBottomNavItems(
                            context,
                            isGuestMode: isGuestMode,
                          ),
                          currentIndex: navSelectedIndex,
                          suppressTabHighlight: hubActive,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          onChanged: onTabTap,
                          selectedColor: context.appColors.primary,
                          unselectedColor:
                              context.appColors.bottomBarTabUnselected,
                          extraActionIcon:
                              isGuestMode ? null : LucideIcons.plus,
                          onExtraActionTap:
                              isGuestMode ? null : onServicesHubTap,
                          extraActionSemanticLabel:
                              context.l10n.servicesHubTitle,
                          extraActionShowsCloseWhenExpanded: false,
                          extraActionIsActive: hubActive,
                        );
                      },
                    );
                  },
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
      ),
    );
  }
}

class _GuestSignInRedirectView extends StatelessWidget {
  const _GuestSignInRedirectView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton.elevated(
        label: context.l10n.guestSignInCta,
        onPressed: () => context.go(Routes.signIn),
      ),
    );
  }
}
