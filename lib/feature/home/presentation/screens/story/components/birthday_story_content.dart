import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_avatar_glow.dart';

class BirthdayStoryContent extends StatelessWidget {
  const BirthdayStoryContent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.message,
  });

  final String imageUrl;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ColoredBox(
      key: const ValueKey('birthday-story-content'),
      color: appColors.background,
      child: Align(
        alignment: const Alignment(0, -0.24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BirthdayAvatarGlow(imageUrl: imageUrl),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: appColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: appColors.text.withValues(alpha: 0.76),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
