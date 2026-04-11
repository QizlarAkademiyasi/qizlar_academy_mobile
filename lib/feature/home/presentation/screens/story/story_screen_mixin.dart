import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:story/story.dart';

mixin StoryScreenMixin<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<IndicatorAnimationCommand>
  indicatorAnimationController;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand.resume,
    );
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  void closeStory(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onStoryDismissed(BuildContext context, DismissDirection direction) {
    closeStory(context);
  }

  void onPageLimitReached(BuildContext context) {
    closeStory(context);
  }

  void onStoryPageChanged({
    required int pageIndex,
    required List<String> categoryIds,
    required ValueChanged<String> onView,
  }) {
    onView(categoryIds[pageIndex]);
  }
}
