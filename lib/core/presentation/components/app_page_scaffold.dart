import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Oddiy ichki ekranlar uchun umumiy themed AppBar.
///
/// Sliver, immersive va rasm ustidagi glass headerlar uchun mo‘ljallanmagan.
class AppPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppPageAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.actions = const [],
    this.centerTitle = false,
    this.backButton,
    this.showBackButton = true,
  });

  final String title;
  final VoidCallback? onBackTap;
  final List<Widget> actions;
  final bool centerTitle;
  final Widget? backButton;
  final bool showBackButton;

  static const double toolbarHeight = 64;

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: context.appColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: toolbarHeight,
      leadingWidth: showBackButton ? 60 : null,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child:
                  backButton ??
                  AppBackButton.ghost(
                    onTap: onBackTap,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                  ),
            )
          : null,
      titleSpacing: centerTitle ? 0 : (showBackButton ? 4 : 20),
      centerTitle: centerTitle,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.heading6.copyWith(
          color: context.appColors.text,
        ),
      ),
      actions: actions.isEmpty ? null : [...actions, const SizedBox(width: 8)],
    );
  }
}

/// Back buttonli oddiy ekranlar uchun umumiy tashqi shell.
///
/// Providerlar bu widgetdan yuqorida turishi kerak:
/// `Screen -> BlocProvider -> View -> AppPageScaffold`.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBackTap,
    this.actions = const [],
    this.centerTitle = false,
    this.backButton,
    this.showBackButton = true,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
    this.safeAreaBottom = false,
  });

  final String title;
  final Widget body;
  final VoidCallback? onBackTap;
  final List<Widget> actions;
  final bool centerTitle;
  final Widget? backButton;
  final bool showBackButton;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.appColors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppPageAppBar(
        title: title,
        onBackTap: onBackTap,
        actions: actions,
        centerTitle: centerTitle,
        backButton: backButton,
        showBackButton: showBackButton,
      ),
      body: SafeArea(top: false, bottom: safeAreaBottom, child: body),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
