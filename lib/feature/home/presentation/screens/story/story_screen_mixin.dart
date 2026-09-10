import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_story_content.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_story_interaction_overlay.dart';

mixin StoryScreenMixin<T extends StatefulWidget> on State<T> {
  List<StoryModel> get storyCategories;
  int get storyInitialIndex;
  ValueChanged<String> get onStoryView;

  late final ValueNotifier<IndicatorAnimationCommand>
  indicatorAnimationController;
  final Set<String> _notifiedViewIds = {};
  final Map<String, BirthdayStoryController> _birthdayControllers = {};
  final Map<String, LayerLink> _birthdayButtonLinks = {};

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
    for (final controller in _birthdayControllers.values) {
      controller.dispose();
    }
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
    if (_isPopped || !mounted) return;
    final navigator = Navigator.of(context);
    if (!navigator.canPop()) return;
    _isPopped = true;
    navigator.pop();
  }

  void onStoryLimitReached() {
    if (_isPopped) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => safePop());
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
      controller: _birthdayController(story),
      congratulateButtonLink: _birthdayButtonLink(story),
    );
  }

  Widget buildBirthdayStoryInteractionOverlay(StoryModel story) {
    return BirthdayStoryInteractionOverlay(
      key: ValueKey('birthday-story-interaction-${story.id}'),
      buttonLink: _birthdayButtonLink(story),
      controller: _birthdayController(story),
    );
  }

  BirthdayStoryController _birthdayController(StoryModel story) {
    return _birthdayControllers.putIfAbsent(
      story.id,
      BirthdayStoryController.new,
    );
  }

  LayerLink _birthdayButtonLink(StoryModel story) {
    return _birthdayButtonLinks.putIfAbsent(story.id, LayerLink.new);
  }
}
