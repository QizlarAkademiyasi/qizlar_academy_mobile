import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/course_curriculum_progress.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_module_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_lesson_tile.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_quiz_list_row.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';

class CourseModuleSection extends StatefulWidget {
  const CourseModuleSection({
    super.key,
    required this.module,
    required this.onLessonTap,
    this.allModules = const [],
    this.sequentialCurriculumEnabled = false,
    this.selectedLessonId,
    this.lessonsLockedUntilEnroll = false,
    this.guestPreviewLessonId,
    this.onGuestLessonAuthRequired,
    this.onOpenQuiz,
  });

  final CourseModuleModel module;
  final void Function(BuildContext context, String lessonId) onLessonTap;
  final List<CourseModuleModel> allModules;
  final bool sequentialCurriculumEnabled;
  final String? selectedLessonId;
  final bool lessonsLockedUntilEnroll;
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestLessonAuthRequired;
  final void Function(String lessonId)? onOpenQuiz;

  @override
  State<CourseModuleSection> createState() => _CourseModuleSectionState();
}

class _CourseModuleSectionState extends State<CourseModuleSection> {
  late ExpandableController _expandController;
  bool _wasExpanded = false;
  int _staggerEpoch = 0;

  void _toastLessonChainLocked(BuildContext context) {
    AppToast.info(context, message: context.l10n.courseLessonSequentialLockedMessage);
  }

  List<Widget> _buildCurriculumRows(BuildContext context) {
    final module = widget.module;
    final stroke = context.appColors.stroke;
    final out = <Widget>[];
    final lessons = module.lessons;
    final modules = widget.allModules;

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final isLast = i == lessons.length - 1;
      final lessonSeqLocked = widget.sequentialCurriculumEnabled && !CourseCurriculumProgress.canAccessLesson(modules, lesson.id);

      out.add(
        CourseLessonTile(
          lesson: lesson,
          isActive: widget.selectedLessonId == lesson.id,
          forceEnrollmentLock: widget.lessonsLockedUntilEnroll,
          guestPreviewLessonId: widget.guestPreviewLessonId,
          onGuestAuthRequired: widget.onGuestLessonAuthRequired,
          modulePrerequisiteLocked: lessonSeqLocked,
          onModulePrerequisiteBlocked: () => _toastLessonChainLocked(context),
          onTap: () => widget.onLessonTap(context, lesson.id),
        ),
      );
      if (widget.onOpenQuiz != null && lesson.hasQuiz) {
        out.add(
          LessonQuizListRow(
            lesson: lesson,
            onOpenQuiz: widget.onOpenQuiz!,
            forceEnrollmentLock: widget.lessonsLockedUntilEnroll,
            guestPreviewLessonId: widget.guestPreviewLessonId,
            onGuestAuthRequired: widget.onGuestLessonAuthRequired,
            modulePrerequisiteLocked: lessonSeqLocked,
            onModulePrerequisiteBlocked: () => _toastLessonChainLocked(context),
          ),
        );
      }
      if (!isLast) {
        out.add(
          Divider(
            height: 1,
            thickness: 1,
            color: stroke,
            indent: AppPadding.paddingLg.left + CourseLessonTile.leadingBadgeSize + 12,
            endIndent: AppPadding.paddingLg.right,
          ),
        );
      }
    }
    return out;
  }

  void _onExpandControllerChanged() {
    final open = _expandController.expandedID == widget.module.id;
    if (open == _wasExpanded) return;
    if (open) Gaimon.light();
    setState(() {
      _wasExpanded = open;
      if (open) _staggerEpoch++;
    });
  }

  @override
  void initState() {
    super.initState();
    final initiallyOpen = widget.module.isExpandedByDefault;
    _expandController = ExpandableController(expandedID: initiallyOpen ? widget.module.id : null);
    _wasExpanded = initiallyOpen;
    _expandController.addListener(_onExpandControllerChanged);
  }

  @override
  void didUpdateWidget(covariant CourseModuleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final moduleIdentityChanged = oldWidget.module.id != widget.module.id;
    final defaultExpandedChanged = oldWidget.module.isExpandedByDefault != widget.module.isExpandedByDefault;
    if (moduleIdentityChanged || defaultExpandedChanged) {
      _expandController.removeListener(_onExpandControllerChanged);
      _expandController.dispose();
      final initiallyOpen = widget.module.isExpandedByDefault;
      _expandController = ExpandableController(expandedID: initiallyOpen ? widget.module.id : null);
      _wasExpanded = initiallyOpen;
      _expandController.addListener(_onExpandControllerChanged);
    }
  }

  @override
  void dispose() {
    _expandController.removeListener(_onExpandControllerChanged);
    _expandController.dispose();
    super.dispose();
  }

  Widget _buildDetails(BuildContext context) {
    final module = widget.module;
    final rows = _buildCurriculumRows(context);

    if (module.lessons.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(thickness: 1, color: context.appColors.stroke),
          Padding(
            padding: AppPadding.paddingLg.copyWith(top: 16),
            child: AppStaggeredScrollLimiter(
              key: ValueKey<String>('${module.id}_$_staggerEpoch'),
              child: AppStaggeredListItem(
                position: 0,
                duration: AppStaggeredListAnimation.duration,
                delay: AppStaggeredListAnimation.staggerDelay,
                verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
                child: const TgsEmptyContent(message: 'Hali darslar yo‘q!'),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(thickness: 1, color: context.appColors.stroke),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: AppPadding.paddingLg.bottom),
          child: AppStaggeredScrollLimiter(
            key: ValueKey<String>('${module.id}_$_staggerEpoch'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(rows.length, (i) {
                return AppStaggeredListItem(
                  position: i,
                  duration: AppStaggeredListAnimation.duration,
                  delay: AppStaggeredListAnimation.staggerDelay,
                  verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
                  child: rows[i],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final cardShape = RoundedRectangleBorder(borderRadius: AppRadius.radius3xl);
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: Theme(
        data: theme.copyWith(
          cardColor: Colors.transparent,
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          listTileTheme: ListTileThemeData(contentPadding: AppPadding.paddingLg),
        ),
        child: ExpandableProvider(
          controller: _expandController,
          child: ExpandableTile(
            id: module.id,
            animationDuration: const Duration(milliseconds: 280),
            marginCollapsed: EdgeInsets.zero,
            marginExpanded: EdgeInsets.zero,
            paddingCollapsed: EdgeInsets.zero,
            paddingExpanded: EdgeInsets.zero,
            elevationCollapsed: 0,
            elevationExpanded: 0,
            shapeCollapsed: cardShape,
            shapeExpanded: cardShape,
            rotateTrailingWhenExpanded: true,
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(module.title, style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(module.progressText, style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.grey)),
            ),
            trailing: Icon(LucideIcons.chevronDown, color: context.appColors.grey, size: 20),
            detailsBuilder: _buildDetails,
          ),
        ),
      ),
    );
  }
}
