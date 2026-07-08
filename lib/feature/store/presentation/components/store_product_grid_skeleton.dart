import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreProductGridSkeleton extends StatelessWidget {
  const StoreProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
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
        itemBuilder: (_, _) => const StoreProductSkeletonCard(),
      ),
    );
  }
}

/// [StoreProductCard] tuzilmasi: rasm + sarlavha + narx qatori.
class StoreProductSkeletonCard extends StatelessWidget {
  const StoreProductSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const Bone.button(),
          ),
        ),
        const SizedBox(height: 8),
        const Bone.text(words: 2),
        const SizedBox(height: 4),
        Row(
          children: const [
            Bone.icon(size: 14),
            SizedBox(width: 4),
            Expanded(child: Bone.text(words: 3)),
            Bone.text(words: 2),
          ],
        ),
      ],
    );
  }
}
