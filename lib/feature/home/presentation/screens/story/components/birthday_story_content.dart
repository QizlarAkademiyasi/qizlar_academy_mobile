import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

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
    return ColoredBox(
      key: const ValueKey('birthday-story-content'),
      color: AppColors.white,
      child: Align(
        alignment: const Alignment(0, -0.24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: imageUrl.trim().isEmpty
                        ? ColoredBox(color: context.appColors.onContainer)
                        : AppCachedNetworkImage(
                            imageUrl: imageUrl.trim(),
                            fit: BoxFit.cover,
                            fallback: const AppNetworkImageFallbackSurface(),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: AppColors.textDark,
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
