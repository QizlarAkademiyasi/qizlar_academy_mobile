import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';

class PortfolioLikeButton extends StatelessWidget {
  const PortfolioLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.likesCount,
    this.iconSize = 16,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
  });

  final bool isLiked;
  final VoidCallback? onTap;
  final int? likesCount;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isLiked ? AppColors.primary : context.appColors.grey;

    return Semantics(
      button: true,
      selected: isLiked,
      label: isLiked ? 'Yoqtirildi' : 'Yoqtirish',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isLiked ? Icons.favorite : LucideIcons.heart,
                  key: ValueKey(isLiked),
                  size: iconSize,
                  color: effectiveColor,
                ),
              ),
              if (likesCount != null) ...[
                const SizedBox(width: 4),
                Text(
                  PortfolioFormatting.compactCount(likesCount!),
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: effectiveColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
