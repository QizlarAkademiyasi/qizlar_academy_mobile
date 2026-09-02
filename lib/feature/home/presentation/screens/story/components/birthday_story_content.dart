import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_avatar_glow.dart';

class BirthdayStoryContent extends StatelessWidget {
  const BirthdayStoryContent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.message,
    this.name = '',
  });

  final String imageUrl;
  final String title;
  final String message;
  final String name;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ColoredBox(
      key: const ValueKey('birthday-story-content'),
      color: appColors.background,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF472B6), Color(0xFFEC4899), Color(0xFFDB2777)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, _) => Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  // StoryPageView paints its progress slider at the very top of
                  // the story. Keep the branded panel below that 3px indicator
                  // plus a small breathing room so the slider never overlays it.
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // Birthday Story is intentionally a light-only branded
                      // surface, even when the rest of the app uses dark mode.
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const _BirthdayConfetti(),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 60, 32, 48),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: appColors.text,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '🎉 Muborak!',
                          textAlign: TextAlign.center,
                          style: context.textTheme.heading3.copyWith(
                            color: const Color(0xFF1F2937),
                            fontSize: 38,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tug‘ilgan kun',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyXLargeBold.copyWith(
                            color: const Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 28),
                        BirthdayAvatarGlow(imageUrl: imageUrl),
                        const SizedBox(height: 28),
                        Text(
                          name.trim().isEmpty ? 'Rayhon' : name,
                          textAlign: TextAlign.center,
                          style: context.textTheme.heading3.copyWith(
                            color: const Color(0xFFEC4899),
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 310),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMediumRegular.copyWith(
                              color: const Color(0xFF6B7280),
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: 220,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF472B6),
                                Color(0xFFEC4899),
                                Color(0xFFDB2777),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFEC4899,
                                ).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            'Tabriklayman! 🎂',
                            style: context.textTheme.bodyXLargeBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirthdayConfetti extends StatelessWidget {
  const _BirthdayConfetti();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      children: const [
        _Confetti(left: 45, top: 45, color: Color(0xFFFF6B6B), angle: -25),
        _Confetti(left: 68, top: 38, color: Color(0xFF4ECDC4), angle: 15),
        _Confetti(left: 90, top: 65, color: Color(0xFFFFD93D), angle: 40),
        _Confetti(left: 275, top: 42, color: Color(0xFFF97316), angle: 20),
        _Confetti(left: 310, top: 60, color: Color(0xFFA78BFA), angle: -18),
        _Confetti(left: 30, top: 280, color: Color(0xFF4ECDC4), angle: -20),
        _Confetti(left: 345, top: 278, color: Color(0xFFA78BFA), angle: 18),
        _Confetti(left: 50, top: 635, color: Color(0xFF60A5FA), angle: 25),
        _Confetti(left: 285, top: 630, color: Color(0xFF4ECDC4), angle: -22),
        _Confetti(left: 315, top: 650, color: Color(0xFFFFD93D), angle: -35),
      ],
    ),
  );
}

class _Confetti extends StatelessWidget {
  const _Confetti({
    required this.left,
    required this.top,
    required this.color,
    required this.angle,
  });
  final double left, top, angle;
  final Color color;
  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    child: Transform.rotate(
      angle: angle * 3.14159 / 180,
      child: Container(
        width: 9,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    ),
  );
}
