import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_story_content.dart';

class BirthdayStoryInteractionOverlay extends StatelessWidget {
  const BirthdayStoryInteractionOverlay({
    super.key,
    required this.buttonLink,
    required this.controller,
  });

  final LayerLink buttonLink;
  final BirthdayStoryController controller;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: buttonLink,
      showWhenUnlinked: false,
      targetAnchor: Alignment.topLeft,
      followerAnchor: Alignment.topLeft,
      child: Align(
        alignment: Alignment.topLeft,
        child: Semantics(
          button: true,
          label: 'Tabriklayman',
          child: GestureDetector(
            key: const ValueKey('birthday-congratulate-button'),
            behavior: HitTestBehavior.opaque,
            onTap: controller.celebrate,
            child: const SizedBox(width: 220, height: 56),
          ),
        ),
      ),
    );
  }
}
