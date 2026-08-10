import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class BirthdayAvatarGlow extends StatefulWidget {
  const BirthdayAvatarGlow({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<BirthdayAvatarGlow> createState() => _BirthdayAvatarGlowState();
}

class _BirthdayAvatarGlowState extends State<BirthdayAvatarGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsDisabled =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_animationsDisabled == animationsDisabled) return;
    _animationsDisabled = animationsDisabled;

    if (animationsDisabled) {
      _controller
        ..stop()
        ..value = 0.5;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final baseHaloAlpha = context.isDarkTheme ? 0.12 : 0.07;

    return RepaintBoundary(
      key: const ValueKey('birthday-avatar-glow'),
      child: SizedBox.square(
        dimension: 116,
        child: AnimatedBuilder(
          animation: _pulse,
          child: ClipOval(
            child: widget.imageUrl.trim().isEmpty
                ? ColoredBox(color: appColors.onContainer)
                : AppCachedNetworkImage(
                    imageUrl: widget.imageUrl.trim(),
                    fit: BoxFit.cover,
                    fallback: const AppNetworkImageFallbackSurface(),
                  ),
          ),
          builder: (context, avatar) {
            final pulse = _pulse.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  key: const ValueKey('birthday-avatar-glow-pulse'),
                  scale: 0.92 + (0.08 * pulse),
                  child: Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      color: appColors.primary.withValues(
                        alpha: baseHaloAlpha * (0.62 + (0.38 * pulse)),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 86,
                  height: 86,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: appColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: appColors.primary.withValues(
                          alpha: 0.14 + (0.10 * pulse),
                        ),
                        blurRadius: 12 + (10 * pulse),
                        spreadRadius: 0.5 + (1.5 * pulse),
                      ),
                    ],
                  ),
                  child: avatar,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
