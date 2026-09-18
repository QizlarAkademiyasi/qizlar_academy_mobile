import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Pastdan modal sheet: [ModalSheetRoute] + [Sheet] ([SheetSize.stretch]).
///
/// [isScrollControlled] — API mosligi (smooth_sheets doim scroll-controlled).
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  SheetScrollHandlingBehavior scrollSyncMode =
      SheetScrollHandlingBehavior.always,
}) {
  return Navigator.of(context).push<T>(
    ModalSheetRoute<T>(
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: true,
      swipeDismissible: true,
      transitionDuration: const Duration(milliseconds: 480),
      transitionCurve: Curves.fastEaseInToSlowEaseOut,
      viewportBuilder: (ctx, sheetChild) {
        final mq = MediaQuery.of(ctx);
        return SheetViewport(
          padding: EdgeInsets.only(
            top: useSafeArea ? mq.padding.top : 0,
            left: useSafeArea ? mq.padding.left : 0,
            right: useSafeArea ? mq.padding.right : 0,
            bottom: mq.viewInsets.bottom,
          ),
          child: sheetChild,
        );
      },
      builder: (_) => Sheet(
        initialOffset: const SheetOffset(1),
        snapGrid: const SheetSnapGrid.stepless(
          minOffset: SheetOffset(0),
          maxOffset: SheetOffset(1),
        ),
        physics: const BouncingSheetPhysics(),
        decoration: MaterialSheetDecoration(
          size: SheetSize.stretch,
          color: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          clipBehavior: Clip.none,
        ),
        scrollConfiguration: SheetScrollConfiguration(
          scrollSyncMode: scrollSyncMode,
        ),
        child: AppTabletMaxWidth(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: child,
          ),
        ),
      ),
    ),
  );
}

class AppBottomSheetContainer extends StatelessWidget {
  const AppBottomSheetContainer({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 0),
    this.showHandle = true,
    this.headerGradient,
    this.isBackgorun = true,
    this.isScrollable = false,
  });

  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showHandle;
  final Gradient? headerGradient;
  final bool isBackgorun;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final scrollMaxHeight = MediaQuery.sizeOf(context).height * 0.55;

    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(8, 0, 8, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: isBackgorun
                  ? DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      scale: 1.5,
                      image: context.isDarkTheme
                          ? UiKitAssets.images.bottomSheet.bottomSheetDark
                                .provider()
                          : UiKitAssets.images.bottomSheet.bottomSheetLight
                                .provider(),
                    )
                  : null,
              color: context.appColors.background,
              borderRadius: AppRadius.radius3xl,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: padding.add(
                      EdgeInsets.only(
                        bottom: MediaQuery.paddingOf(context).bottom,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showHandle)
                          Align(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: context.appColors.text,
                                borderRadius: AppRadius.radius2,
                              ),
                            ),
                          ),
                        if (title != null && title!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            title!,
                            style: context.textTheme.bodyXLargeSemibold
                                .copyWith(color: context.appColors.text),
                          ),
                        ],
                        if (showHandle || (title != null && title!.isNotEmpty))
                          const SizedBox(height: 16),
                        if (isScrollable)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: scrollMaxHeight,
                            ),
                            child: SingleChildScrollView(child: child),
                          )
                        else
                          child,
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
