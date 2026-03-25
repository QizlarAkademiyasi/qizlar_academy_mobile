import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Peshqadamlar kartasi uchun skeleton — yuklanishda [CircularProgressIndicator] o'rniga.
class LeaderboardTopPerformersSkeleton extends StatelessWidget {
  const LeaderboardTopPerformersSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radius3xl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Bone.circle(size: 40),
                  const SizedBox(height: 8),
                  Bone.text(words: 1),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  Bone.circle(size: 48),
                  const SizedBox(height: 8),
                  Bone.text(words: 1),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  Bone.circle(size: 40),
                  const SizedBox(height: 8),
                  Bone.text(words: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
