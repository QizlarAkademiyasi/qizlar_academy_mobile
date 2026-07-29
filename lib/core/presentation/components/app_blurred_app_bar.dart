import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_blurred_header_surface.dart';

/// Status bar hududini ham qamrab oladigan umumiy glass AppBar.
class AppBlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBlurredAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.centerTitle,
    this.titleSpacing,
    this.leadingWidth,
    this.toolbarHeight = kToolbarHeight,
    this.bottom,
    this.blurSigma = 18,
    this.backgroundOpacity = 0.82,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? leadingWidth;
  final double toolbarHeight;
  final PreferredSizeWidget? bottom;
  final double blurSigma;
  final double backgroundOpacity;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: context.isDarkTheme
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      leading: leading,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: title,
      actions: actions,
      bottom: bottom,
      flexibleSpace: AppBlurredHeaderSurface(
        blurSigma: blurSigma,
        backgroundOpacity: backgroundOpacity,
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Scroll kontenti ortidan o'tadigan pinned glass sliver AppBar.
class AppBlurredSliverAppBar extends StatelessWidget {
  const AppBlurredSliverAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.centerTitle,
    this.titleSpacing,
    this.leadingWidth,
    this.toolbarHeight = kToolbarHeight,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.bottom,
    this.blurSigma = 18,
    this.backgroundOpacity = 0.82,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? leadingWidth;
  final double toolbarHeight;
  final bool pinned;
  final bool floating;
  final bool snap;
  final PreferredSizeWidget? bottom;
  final double blurSigma;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: snap,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: context.isDarkTheme
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      leading: leading,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: title,
      actions: actions,
      bottom: bottom,
      flexibleSpace: AppBlurredHeaderSurface(
        blurSigma: blurSigma,
        backgroundOpacity: backgroundOpacity,
        child: const SizedBox.expand(),
      ),
    );
  }
}
