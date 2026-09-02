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
    const avatarFallbackColor = Color(0xFFE5E7EB);
    const baseHaloAlpha = 0.07;

    return RepaintBoundary(
      key: const ValueKey('birthday-avatar-glow'),
      child: SizedBox.square(
        dimension: 180,
        child: AnimatedBuilder(
          animation: _pulse,
          child: ClipOval(
            child: widget.imageUrl.trim().isEmpty
                ? const ColoredBox(color: avatarFallbackColor)
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
                  scale: 0.96 + (0.04 * pulse),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: appColors.primary.withValues(
                            alpha: baseHaloAlpha + (0.06 * pulse),
                          ),
                          blurRadius: 16 + (6 * pulse),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 172,
                  height: 172,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      avatar ?? const SizedBox.shrink(),
                      IgnorePointer(
                        child: Transform.translate(
                          // The exported SVG ellipse occupies only ~82% of its
                          // canvas and sits slightly above center. Scale it so
                          // the pink stroke follows the photo's outer edge.
                          offset: const Offset(0, 10),
                          child: Transform.scale(
                            scale: 1.22,
                            child: SvgPicture.asset(
                              'assets/birthday/birthday_ring.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
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
