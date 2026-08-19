import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class AiChatLoadingSkeleton extends StatelessWidget {
  const AiChatLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
        child: Column(
          children: [
            Bone.circle(size: 88),
            const SizedBox(height: 20),
            SizedBox(width: 220, child: Bone.text(words: 3)),
            const SizedBox(height: 44),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Bone(width: 130, height: 48, borderRadius: AppRadius.radiusXl),
                const SizedBox(width: 10),
                Bone(width: 130, height: 48, borderRadius: AppRadius.radiusXl),
              ],
            ),
            const SizedBox(height: 10),
            Bone(width: 150, height: 48, borderRadius: AppRadius.radiusXl),
          ],
        ),
      ),
    );
  }
}
