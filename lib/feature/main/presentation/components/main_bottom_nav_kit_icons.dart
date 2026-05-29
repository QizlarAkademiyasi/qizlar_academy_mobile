import 'package:flutter/widgets.dart';
import 'package:qizlar_academy_kit/gen/assets.gen.dart';

/// Kit `bottomNavBar` SVG'lari — pastki navigatsiya uchun bir xil ko‘rinish.
abstract final class MainBottomNavKitIcons {
  static Widget _tabSvg({required SvgGenImage outlined, required SvgGenImage filled, required bool selected, required Color color, required double size}) {
    final asset = selected ? filled : outlined;
    return asset.svg(
      width: size,
      height: size,
      // colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget home(Color color, double size, bool selected) =>
      _tabSvg(outlined: UiKitAssets.svgs.icons.bottomNavBar.mainOutlined, filled: UiKitAssets.svgs.icons.bottomNavBar.mainFilled, selected: selected, color: color, size: size);

  static Widget courses(Color color, double size, bool selected) =>
      _tabSvg(outlined: UiKitAssets.svgs.icons.bottomNavBar.coursesOutlined, filled: UiKitAssets.svgs.icons.bottomNavBar.coursesFilled, selected: selected, color: color, size: size);

  static Widget leaderboard(Color color, double size, bool selected) =>
      _tabSvg(outlined: UiKitAssets.svgs.icons.bottomNavBar.crownOutlined, filled: UiKitAssets.svgs.icons.bottomNavBar.crownFilled, selected: selected, color: color, size: size);

  static Widget user(Color color, double size, bool selected) =>
      _tabSvg(outlined: UiKitAssets.svgs.icons.bottomNavBar.userOutlined, filled: UiKitAssets.svgs.icons.bottomNavBar.userFilled, selected: selected, color: color, size: size);
}
