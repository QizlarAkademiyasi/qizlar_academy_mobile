import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_bottom_action.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_module_section.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_progress_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_player_completed_badge.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_player_quiz_cta.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';

class CourseLessonPlayerScreen extends StatefulWidget {
  const CourseLessonPlayerScreen({super.key, required this.args});

  final CourseLessonPlayerArgs args;

  @override
  State<CourseLessonPlayerScreen> createState() => _CourseLessonPlayerScreenState();
}

class _CourseLessonPlayerScreenState extends State<CourseLessonPlayerScreen> with CourseLessonPlayerScreenMixin<CourseLessonPlayerScreen> {
  @override
  CourseLessonPlayerArgs get args => widget.args;

  @override
  Widget build(BuildContext context) {
    final lesson = selectedLesson;
    final playerHeight = MediaQuery.sizeOf(context).width * 9 / 16;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final showQuizCta =
        isRegistered && lesson != null && lesson.isCompleted && lesson.hasQuiz && !lesson.hasCompletedLessonQuiz;
    final showCompleteCta = isRegistered && lesson != null && !lesson.isCompleted;
    final hasBottomDock = showCompleteCta || showQuizCta;
    const double dockBarHeight = 56;
    final double scrollBottomPadding = hasBottomDock ? 16 + dockBarHeight + bottomInset : 20;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: lesson == null
            ? TgsEmptyContent(message: context.l10n.lessonEmpty)
            : Stack(
                children: [
                  CustomScrollView(
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
                                  decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () => context.pop(),
                                    icon: const Icon(LucideIcons.chevronLeft, color: AppColors.white),
                                    tooltip: context.l10n.lessonBackTooltip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.lessonProgress(lesson.order, args.course.lessonsCount),
                                style: context.textTheme.bodySmallMedium.copyWith(color: AppColors.primary, letterSpacing: 0.2),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lesson.title,
                                style: context.textTheme.heading6.copyWith(
                                  color: context.appColors.text,
                                  fontSize: 20,
                                  height: 1.25,
                                ),
                              ),
                              if (isRegistered && lesson.isCompleted) ...[
                                const SizedBox(height: 14),
                                LessonPlayerCompletedBadge(label: context.l10n.lessonCompleted),
                              ],
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  if (args.course.teacherAvatarUrl.trim().isNotEmpty) ...[
                                    ClipOval(
                                      child: AppCachedNetworkImage(
                                        imageUrl: args.course.teacherAvatarUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        fallback: const AppNetworkImageFallbackAvatar(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Expanded(
                                    child: Text(
                                      args.course.teacherName,
                                      style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey, height: 1.35),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
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
                        padding: EdgeInsets.fromLTRB(20, 8, 20, scrollBottomPadding),
                        sliver: SliverList.builder(
                          itemCount: modulesWithHydratedLessons.length,
                          itemBuilder: (context, index) {
                            final module = modulesWithHydratedLessons[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: CourseModuleSection(
                                module: module,
                                selectedLessonId: lesson.id,
                                onLessonTap: onLessonTap,
                                onOpenQuiz: isRegistered ? (id) => openLessonQuizFromPlayer(context, lessonId: id) : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (hasBottomDock)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: bottomInset + 8,
                      child: showCompleteCta
                          ? CourseBottomAction(
                              label: context.l10n.lessonMarkComplete,
                              leadingIcon: LucideIcons.circleCheck,
                              onTap: completeSelectedLesson,
                              enabled: !isCompleting,
                              isLoading: isCompleting,
                            )
                          : LessonPlayerQuizCta(
                              lessonId: lesson.id,
                              onOpenQuiz: () => openLessonQuizFromPlayer(context, lessonId: lesson.id),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(color: AppColors.black, child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedVideoHeaderDelegate oldDelegate) {
    return oldDelegate.extent != extent || oldDelegate.child != child;
  }
}
