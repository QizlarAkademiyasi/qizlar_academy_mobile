import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// "To'liq reyting" bloki uchun skeleton — mock foydalanuvchilar o'rniga Bone.
class LeaderboardFullListSkeleton extends StatelessWidget {
  const LeaderboardFullListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(words: 2, fontSize: 18),
          const SizedBox(height: 12),
          ...List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: context.appColors.onContainer,
                  borderRadius: AppRadius.radiusXl,
                  border: Border.all(color: context.appColors.stroke),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 28, child: Bone.text(words: 1)),
                    const SizedBox(width: 12),
                    Bone.circle(size: 44),
                    const SizedBox(width: 12),
                    const Expanded(child: Bone.text(words: 2)),
                    const SizedBox(width: 8),
                    Bone.text(words: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
