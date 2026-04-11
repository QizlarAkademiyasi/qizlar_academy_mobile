import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Pastdan modal sheet: [ModalSheetRoute] + [Sheet] ([SheetSize.fit]). [isScrollControlled] — API mosligi.
Future<T?> showAppBottomSheet<T>(BuildContext context, {required Widget child, bool isScrollControlled = true, bool useSafeArea = true}) {
  return Navigator.of(context).push<T>(
    ModalSheetRoute<T>(
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: true,
      swipeDismissible: true,
      transitionDuration: const Duration(milliseconds: 360),
      transitionCurve: Curves.easeOutCubic,
      viewportBuilder: (ctx, sheetChild) {
        final mq = MediaQuery.of(ctx);
        return SheetViewport(
          padding: EdgeInsets.only(top: useSafeArea ? mq.padding.top : 0, left: useSafeArea ? mq.padding.left : 0, right: useSafeArea ? mq.padding.right : 0, bottom: mq.viewInsets.bottom),
          child: sheetChild,
        );
      },
      builder: (_) => Sheet(
        initialOffset: const SheetOffset(1),
        snapGrid: const SheetSnapGrid.single(snap: SheetOffset(1)),
        physics: const BouncingSheetPhysics(),
        decoration: MaterialSheetDecoration(size: SheetSize.fit, color: Colors.transparent, elevation: 0, shadowColor: Colors.transparent),
        scrollConfiguration: const SheetScrollConfiguration(scrollSyncMode: SheetScrollHandlingBehavior.onlyFromTop),
        child: AppTabletMaxWidth(child: child),
      ),
    ),
  );
}

class AppBottomSheetContainer extends StatelessWidget {
  const AppBottomSheetContainer({super.key, this.title, required this.child, this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 0), this.showHandle = true, this.headerGradient});

  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showHandle;
  final Gradient? headerGradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(8, 0, 8, 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            scale: 1.5,
            image: context.isDarkTheme ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider() : UiKitAssets.images.bottomSheet.bottomSheetLight.provider(),
          ),
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
                padding: padding.add(EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showHandle)
                      Align(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: context.appColors.text, borderRadius: AppRadius.radius2),
                        ),
                      ),
                    if (title != null && title!.isNotEmpty) ...[const SizedBox(height: 16), Text(title!, style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text))],
                    if (showHandle || (title != null && title!.isNotEmpty)) const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
