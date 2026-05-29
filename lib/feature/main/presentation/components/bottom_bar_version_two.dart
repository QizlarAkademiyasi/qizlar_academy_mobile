import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/bottom_bar_version_one.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/services/profile_avatar_refresh_notifier.dart';

/// MainBottomBar — `LiquidGlassBottomBar` (liquid_glass_renderer) asosidagi wrapper.
///
/// `main_screen_mixin.dart` dagi `GlassBottomNavigationVersionTwo` chaqirig'i
/// aynan shu widget bilan ishlaydi.
class GlassBottomNavigationVersionTwo extends StatefulWidget {
  const GlassBottomNavigationVersionTwo({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static List<LiquidGlassBottomBarTab> _tabs(BuildContext context) {
    final l10n = context.l10n;
    return [
      LiquidGlassBottomBarTab(label: l10n.mainTabHome, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.home(color, size, selected)),
      LiquidGlassBottomBarTab(label: l10n.mainTabCourses, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.courses(color, size, selected)),
      LiquidGlassBottomBarTab(label: l10n.mainTabLeaderboard, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.leaderboard(color, size, selected)),
      LiquidGlassBottomBarTab(label: l10n.mainTabProfile, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.user(color, size, selected)),
    ];
  }

  @override
  State<GlassBottomNavigationVersionTwo> createState() => _GlassBottomNavigationVersionTwoState();
}

class _GlassBottomNavigationVersionTwoState extends State<GlassBottomNavigationVersionTwo> {
  static const int _profileTabIndex = 3;
  static const double _barHeight = 65;
  static const double _horizontalPadding = 24;
  static const double _verticalPadding = 24;
  static const double _avatarSize = 24;
  static const double _avatarTopOffset = 24;

  Future<String?> _loadAvatarUrl() async {
    try {
      final overview = await getIt<ProfileRepository>().getProfileOverview();
      final avatarUrl = overview.user.avatarUrl.trim();
      if (avatarUrl.isEmpty) return null;
      return Apis.resolveUrl(avatarUrl);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final appColors = context.appColors;
    final indicatorColor = appColors.bottomBarIndicator;

    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListenableBuilder(
          listenable: getIt<ProfileAvatarRefreshNotifier>(),
          builder: (context, _) {
            final avatarGen = getIt<ProfileAvatarRefreshNotifier>().generation;
            return FutureBuilder<String?>(
              key: ValueKey<int>(avatarGen),
              future: _loadAvatarUrl(),
              builder: (context, snapshot) {
                final avatarUrl = snapshot.data;
                final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

                final tabs = GlassBottomNavigationVersionTwo._tabs(context);
                return Stack(
                  children: [
                    LiquidGlassBottomBar(
                      tabs: tabs,
                      selectedIndex: widget.currentIndex,
                      onTabSelected: widget.onTap,
                      barHeight: _barHeight,
                      horizontalPadding: _horizontalPadding,
                      bottomPadding: _verticalPadding,
                      indicatorColor: indicatorColor,
                      glassSettings: LiquidGlassSettings(
                        refractiveIndex: 1.18,
                        thickness: 20,
                        blur: 5,
                        saturation: 1,
                        lightIntensity: isDark ? .3 : .9,
                        ambientStrength: isDark ? .5 : .4,
                        lightAngle: math.pi / 3,
                        glassColor: appColors.bottomBarGlass,
                      ),
                    ),
                    if (hasAvatar)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                            child: Row(
                              children: List.generate(
                                tabs.length,
                                (index) => Expanded(
                                  child: index == _profileTabIndex
                                      ? Align(
                                          alignment: const Alignment(-0.1, -_avatarTopOffset / _barHeight),
                                          child: _ProfileTabAvatar(imageUrl: avatarUrl, avatarImageGeneration: avatarGen, selected: widget.currentIndex == _profileTabIndex, size: _avatarSize),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProfileTabAvatar extends StatelessWidget {
  const _ProfileTabAvatar({required this.imageUrl, required this.avatarImageGeneration, required this.selected, required this.size});

  final String imageUrl;
  final int avatarImageGeneration;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final borderColor = selected ? appColors.primary : appColors.bottomBarTabUnselected;
    final cacheKey = '$imageUrl#$avatarImageGeneration';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: selected ? Border.all(color: borderColor, width: 1.5) : null,
      ),
      child: ClipOval(
        child: AppCachedNetworkImage(
          imageUrl: imageUrl,
          cacheKey: cacheKey,
          fit: BoxFit.cover,
          width: size,
          height: size,
          fallback: AppNetworkImageFallbackAvatar(iconSize: size * 0.7, iconColor: borderColor, placeholderShowsIcon: false, errorShowsBackground: false),
        ),
      ),
    );
  }
}
