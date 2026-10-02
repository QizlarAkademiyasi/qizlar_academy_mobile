import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

class GameWebViewLoadingSkeleton extends StatelessWidget {
  const GameWebViewLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appColors.background,
      child: Center(
        child: Skeletonizer.zone(
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Bone.square(size: 96),
              SizedBox(height: 20),
              SizedBox(width: 180, child: Bone.text(words: 3)),
              SizedBox(height: 10),
              SizedBox(width: 120, child: Bone.text(words: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
