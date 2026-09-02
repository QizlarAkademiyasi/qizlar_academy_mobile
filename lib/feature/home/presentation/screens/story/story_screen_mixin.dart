import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_story_content.dart';

mixin StoryScreenMixin<T extends StatefulWidget> on State<T> {
  List<StoryModel> get storyCategories;
  int get storyInitialIndex;
  ValueChanged<String> get onStoryView;

  late final ValueNotifier<IndicatorAnimationCommand>
  indicatorAnimationController;
  final Set<String> _notifiedViewIds = {};

  double dismissProgress = 0;
  bool _isPopped = false;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = storyCategories.isEmpty
        ? 0
        : storyInitialIndex.clamp(0, storyCategories.length - 1);
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand.resume,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || storyCategories.isEmpty) return;
      notifyStoryViewed(storyCategories[currentIndex]);
    });
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  void notifyStoryViewed(StoryModel story) {
    if (story.canTrackView && _notifiedViewIds.add(story.id)) {
      onStoryView(story.id);
    }
  }

  void updateDismissProgress(double progress) {
    if (_isPopped) return;
    if (progress > 0.25) {
      safePop();
      return;
    }
    setState(() => dismissProgress = progress);
  }

  void safePop() {
    if (_isPopped) return;
    _isPopped = true;
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void onStoryPageChanged(int pageIndex) {
    setState(() => currentIndex = pageIndex);
    notifyStoryViewed(storyCategories[pageIndex]);
  }

  Widget buildBirthdayStoryContent(BuildContext context, StoryModel story) {
    return BirthdayStoryContent(
      imageUrl: story.imageUrl,
      title: context.l10n.birthdayStoryCongratulations,
      message: context.l10n.birthdayStoryMessage,
      name: story.name,
    );
  }
}
