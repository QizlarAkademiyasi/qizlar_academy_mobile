import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    sheetAnimationStyle: const AnimationStyle(
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutBack,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 280),
    ),
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (ctx) => _AppBottomSheetEntrance(child: child),
  );
}

class _AppBottomSheetEntrance extends StatefulWidget {
  const _AppBottomSheetEntrance({required this.child});

  final Widget child;

  @override
  State<_AppBottomSheetEntrance> createState() =>
      _AppBottomSheetEntranceState();
}

class _AppBottomSheetEntranceState extends State<_AppBottomSheetEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _slideAnimation, child: widget.child);
  }
}

class AppBottomSheetContainer extends StatelessWidget {
  const AppBottomSheetContainer({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.showHandle = true,
    this.headerGradient,
  });

  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showHandle;
  final Gradient? headerGradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            scale: 1.5,
            image: context.isDarkTheme
                ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider()
                : UiKitAssets.images.bottomSheet.bottomSheetLight.provider(),
          ),
          color: context.appColors.background,
          borderRadius: AppRadius.radius3xl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Stack(
          children: [
            SafeArea(
              top: false,
              child: Padding(
                padding: padding.add(
                  EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
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
                        style: context.textTheme.bodyXLargeSemibold.copyWith(
                          color: context.appColors.text,
                        ),
                      ),
                    ],
                    if (showHandle || (title != null && title!.isNotEmpty))
                      const SizedBox(height: 16),
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
