import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart' as kit;
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

/// MainBottomBar — `liquid_glass_widgets` asosidagi wrapper.
///
/// `main_screen_mixin.dart` dagi `GlassBottomNavigationVersionTwo` chaqirig'i
/// aynan shu widget bilan ishlaydi.
class GlassBottomNavigationVersionTwo extends StatefulWidget {
  const GlassBottomNavigationVersionTwo({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<kit.GlassBottomBarTab> _tabs = [
    kit.GlassBottomBarTab(
      label: 'Asosiy',
      icon: LucideIcons.house,
      selectedIcon: LucideIcons.house,
    ),
    kit.GlassBottomBarTab(
      label: 'Kurslar',
      icon: LucideIcons.bookOpen,
      selectedIcon: LucideIcons.bookOpen,
    ),
    kit.GlassBottomBarTab(
      label: 'Liderlar',
      icon: LucideIcons.trophy,
      selectedIcon: LucideIcons.trophy,
    ),
    kit.GlassBottomBarTab(
      label: 'Profil',
      icon: LucideIcons.user,
      selectedIcon: LucideIcons.user,
    ),
  ];

  @override
  State<GlassBottomNavigationVersionTwo> createState() =>
      _GlassBottomNavigationVersionTwoState();
}

class _GlassBottomNavigationVersionTwoState
    extends State<GlassBottomNavigationVersionTwo> {
  static const int _profileTabIndex = 3;
  static const double _barHeight = 65;
  static const double _horizontalPadding = 24;
  static const double _verticalPadding = 24;
  static const double _avatarSize = 24;
  static const double _avatarTopOffset = 24;

  late final Future<String?> _avatarUrlFuture = _loadAvatarUrl();

  Future<String?> _loadAvatarUrl() async {
    try {
      final overview = await getIt<ProfileRepository>().getProfileOverview();
      final avatarUrl = overview.user.avatarUrl.trim();
      if (avatarUrl.isEmpty) return null;
      return avatarUrl;
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
        child: FutureBuilder<String?>(
          future: _avatarUrlFuture,
          builder: (context, snapshot) {
            final avatarUrl = snapshot.data;
            final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

            return Stack(
              children: [
                kit.GlassBottomBar(
                  tabs: GlassBottomNavigationVersionTwo._tabs,
                  selectedIndex: widget.currentIndex,
                  onTabSelected: widget.onTap,
                  quality: kit.GlassQuality.premium,
                  barHeight: _barHeight,
                  horizontalPadding: _horizontalPadding,
                  verticalPadding: _verticalPadding,
                  selectedIconColor: appColors.primary,
                  unselectedIconColor: appColors.bottomBarTabUnselected,
                  indicatorColor: indicatorColor,
                  indicatorSettings: LiquidGlassSettings(
                    glassColor: appColors.bottomBarIndicator,
                    refractiveIndex: 1.25,
                    thickness: 18,
                    saturation: 1.15,
                    chromaticAberration: 0.25,
                    blur: 0,
                    lightIntensity: isDark ? 0.3 : 1.25,
                  ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: _horizontalPadding,
                          vertical: _verticalPadding,
                        ),
                        child: Row(
                          children: List.generate(
                            GlassBottomNavigationVersionTwo._tabs.length,
                            (index) => Expanded(
                              child: index == _profileTabIndex
                                  ? Align(
                                      alignment: const Alignment(
                                        -0.1,
                                        -_avatarTopOffset / _barHeight,
                                      ),
                                      child: _ProfileTabAvatar(
                                        imageUrl: avatarUrl,
                                        selected:
                                            widget.currentIndex ==
                                            _profileTabIndex,
                                        size: _avatarSize,
                                      ),
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
        ),
      ),
    );
  }
}

class _ProfileTabAvatar extends StatelessWidget {
  const _ProfileTabAvatar({
    required this.imageUrl,
    required this.selected,
    required this.size,
  });

  final String imageUrl;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final borderColor = selected
        ? appColors.primary
        : appColors.bottomBarTabUnselected;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: selected ? Border.all(color: borderColor, width: 1.5) : null,
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          color: selected
              ? null
              : context.appColors.bigOpacity.withValues(alpha: 0.6),
          width: size,
          height: size,
          errorWidget: (_, _, _) =>
              Icon(LucideIcons.user, size: size * 0.7, color: borderColor),
        ),
      ),
    );
  }
}
