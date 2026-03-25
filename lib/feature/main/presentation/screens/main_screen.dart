import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/screens/profile_screen.dart';

import '../../../home/presentation/screens/home_screen_main.dart'
    show HomeScreen;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with MainScreenMixin<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _KeepAlivePage(child: HomeScreen()),
                _KeepAlivePage(child: CoursesScreen()),
                _KeepAlivePage(child: LeaderboardScreen()),
                _KeepAlivePage(child: ProfileScreen()),
              ],
            ),
          ),
          if (Platform.isIOS)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 32,
                      color: AppColors.shadow.withValues(alpha: 0.14),
                    ),
                  ],
                ),
                child: buildGlassBottomBarVersionTwo(context),
              ),
            ),
        ],
      ),
      bottomNavigationBar: (Platform.isAndroid)
          ? buildBottomNavigationBar(context)
          : null,
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin<_KeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
