import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_one.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_two.dart';

/// Main shell ekrani uchun tab tanlashi va pastki bar qismini qaytaruvchi mixin.
mixin MainScreenMixin<T extends StatefulWidget> on State<T> {
  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;
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
    _handleTabTap(index);
  }

  Future<void> _handleTabTap(int index) async {
    // Gaimon.light();
    if (_selectedIndex == index) return;

    final shouldGateProfile = index == 3 && getIt<AuthSessionCubit>().state.isAnonymous;
    if (shouldGateProfile) {
      final canOpen = await getIt<GuestTapGateService>().allowAction(
        context,
        key: 'tab_profile',
        title: 'Profil uchun ro‘yxatdan o‘ting',
      );
      if (!canOpen) return;
    }

    // Bottom bar UI first yangilansin; og'ir sahifa build bo'lsa ham
    // tanlangan tab "qotib qolgan"dek ko'rinmasin.
    setState(() => _selectedIndex = index);

    // Yangi og'ir sahifani qurish (jumpToPage) pastki bardagi
    // vizual o'zgarish/animatsiya tugagandan so'ng amalga oshiriladi
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted || !pageController.hasClients) return;
      pageController.jumpToPage(index);
    });
  }

  void onPageChanged(int index) {
    Gaimon.light();
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildProfileTabIcon(BuildContext context, {required bool selected}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(UiKitAssets.images.logo.path)),
      ),

      child: ClipOval(
        child: UiKitAssets.images.logo.image(
          fit: BoxFit.cover,
          color: selected
              ? context.appColors.bigOpacity.withValues(alpha: 0.1)
              : context.appColors.bigOpacity.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
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
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: selectedIndex,
        onTap: onTabTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.house),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.bookOpen),
            label: 'Courses',
          ),
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.crown),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: _buildProfileTabIcon(context, selected: false),
            activeIcon: _buildProfileTabIcon(context, selected: true),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTabTap,
      destinations: [
        const NavigationDestination(
          icon: Icon(LucideIcons.house),
          selectedIcon: Icon(LucideIcons.house, color: AppColors.white),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(LucideIcons.bookOpen),
          selectedIcon: Icon(LucideIcons.bookOpen, color: AppColors.white),
          label: 'Courses',
        ),
        const NavigationDestination(
          icon: Icon(LucideIcons.crown),
          selectedIcon: Icon(LucideIcons.crown, color: AppColors.white),
          label: 'Leaderboard',
        ),
        NavigationDestination(
          icon: _buildProfileTabIcon(context, selected: false),
          selectedIcon: _buildProfileTabIcon(context, selected: true),
          label: 'Profile',
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
