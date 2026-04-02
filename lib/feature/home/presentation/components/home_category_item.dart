import 'dart:math';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';

class StoryBoardItem extends StatelessWidget {
  const StoryBoardItem({super.key, required this.story});

  final StoryModel story;

  static const List<Color> _gradientColors = [
    AppColors.otherRed,
    AppColors.otherPink,
    AppColors.otherPurple,
    AppColors.otherDeepPurple,
    AppColors.otherIndigo,
    AppColors.otherBlue,
    AppColors.otherLightBlue,
    AppColors.otherCyan,
    AppColors.otherTeal,
    AppColors.otherGreen,
    AppColors.otherLightGreen,
    AppColors.otherLime,
    AppColors.otherYellow,
    AppColors.otherAmber,
    AppColors.otherOrange,
    AppColors.otherDeepOrange,
    AppColors.otherBrown,
    AppColors.otherBlueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final firstGradientColor = _gradientColors[random.nextInt(_gradientColors.length)];
    var secondGradientColor = _gradientColors[random.nextInt(_gradientColors.length)];

    while (secondGradientColor == firstGradientColor && _gradientColors.length > 1) {
      secondGradientColor = _gradientColors[random.nextInt(_gradientColors.length)];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bounce(
            onTap: () {},
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.onContainer,
                border: Border.all(color: firstGradientColor, width: 3),
                // gradient: LinearGradient(
                //   colors: [
                //     firstGradientColor,
                //     firstGradientColor.withValues(alpha: 0.5),
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: story.thumbnailUrl.trim().isEmpty
                    ? const _StoryImageSkeleton()
                    : AppCachedNetworkImage(
                        imageUrl: story.thumbnailUrl.trim(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const _StoryImageSkeleton(),
                        errorWidget: (context, url, error) => const _StoryImageSkeleton(),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            story.name,
            style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.text),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StoryImageSkeleton extends StatelessWidget {
  const _StoryImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(color: context.appColors.onContainer, shape: BoxShape.circle),
        child: const SizedBox.expand(),
      ),
    );
  }
}
