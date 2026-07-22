import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class StoreOrderHistoryGridSkeleton extends StatelessWidget {
  const StoreOrderHistoryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          childAspectRatio: 0.64,
        ),
        itemBuilder: (_, _) => const StoreOrderHistorySkeletonCard(),
      ),
    );
  }
}

/// [StoreOrderHistoryGridItem] tuzilmasi: rasm, sarlavha, narx qatori, tag.
class StoreOrderHistorySkeletonCard extends StatelessWidget {
  const StoreOrderHistorySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.onContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.appColors.stroke.withValues(alpha: 0.7),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: const Bone.button(),
            ),
          ),
          const SizedBox(height: 10),
          const Bone.text(words: 3),
          const SizedBox(height: 6),
          Row(
            children: const [
              Bone.icon(size: 12),
              SizedBox(width: 4),
              Expanded(child: Bone.text(words: 3)),
              SizedBox(width: 8),
              SizedBox(width: 32, child: Bone.text(words: 1)),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const SizedBox(height: 22, width: 72, child: Bone.button()),
          ),
        ],
      ),
    );
  }
}
