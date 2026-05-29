import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreProductGridSkeleton extends StatelessWidget {
  const StoreProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.62,
        ),
        itemCount: 4,
        itemBuilder: (_, _) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 8),
        const Bone.text(words: 2),
        const SizedBox(height: 4),
        const Bone.text(words: 3, fontSize: 12),
      ],
    );
  }
}
