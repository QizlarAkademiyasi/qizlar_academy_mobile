import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

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
                SizedBox(width: 130, height: 48, child: Bone.button()),
                const SizedBox(width: 10),
                SizedBox(width: 130, height: 48, child: Bone.button()),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(width: 150, height: 48, child: Bone.button()),
          ],
        ),
      ),
    );
  }
}
