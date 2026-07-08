import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class PortfolioAvatar extends StatelessWidget {
  const PortfolioAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    this.size = 32,
  });

  final String photoUrl;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'P'
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part.characters.first.toUpperCase())
              .join();
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: photoUrl.trim().isEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: context.textTheme.bodySmallBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            : AppCachedNetworkImage(
                imageUrl: photoUrl,
                width: size,
                height: size,
                fallback: const AppNetworkImageFallbackAvatar(iconSize: 16),
              ),
      ),
    );
  }
}
