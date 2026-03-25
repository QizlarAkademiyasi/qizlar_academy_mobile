import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_module_section.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_progress_card.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';

class CourseLessonPlayerScreen extends StatefulWidget {
  const CourseLessonPlayerScreen({super.key, required this.args});

  final CourseLessonPlayerArgs args;

  @override
  State<CourseLessonPlayerScreen> createState() =>
      _CourseLessonPlayerScreenState();
}

class _CourseLessonPlayerScreenState extends State<CourseLessonPlayerScreen>
    with CourseLessonPlayerScreenMixin<CourseLessonPlayerScreen> {
  @override
  CourseLessonPlayerArgs get args => widget.args;

  @override
  Widget build(BuildContext context) {
    final lesson = selectedLesson;
    final playerHeight = MediaQuery.sizeOf(context).width * 9 / 16;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: lesson == null
            ? const TgsEmptyContent(message: 'Hali ochiq darslar yo‘q')
            : CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PinnedVideoHeaderDelegate(
                      extent: playerHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          buildVideoPlayer(context, lesson: lesson),
                          Positioned(
                            left: 12,
                            top: 12,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(
                                  LucideIcons.chevronLeft,
                                  color: AppColors.white,
                                ),
                                tooltip: 'Orqaga',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dars ${lesson.order}/${args.course.lessonsCount}',
                            style: context.textTheme.bodySmallMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lesson.title,
                            style: context.textTheme.bodyMediumBold.copyWith(
                              color: context.appColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            args.course.teacherName,
                            style: context.textTheme.bodySmallRegular.copyWith(
                              color: context.appColors.grey,
                            ),
                          ),
                          const SizedBox(height: 14),
                          CourseProgressCard(
                            progressLabel: args.course.progressLessonsText,
                            progressSeenText: args.course.progressSeenText,
                            progressTotalText: args.course.progressDurationText,
                            progressRatio: args.course.progressRatio,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                    sliver: SliverList.builder(
                      itemCount: args.course.modules.length,
                      itemBuilder: (context, index) {
                        final module = args.course.modules[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: CourseModuleSection(
                            module: module,
                            selectedLessonId: lesson.id,
                            onLessonTap: onLessonTap,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PinnedVideoHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedVideoHeaderDelegate({required this.extent, required this.child});

  final double extent;
  final Widget child;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: AppColors.black,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedVideoHeaderDelegate oldDelegate) {
    return oldDelegate.extent != extent || oldDelegate.child != child;
  }
}
