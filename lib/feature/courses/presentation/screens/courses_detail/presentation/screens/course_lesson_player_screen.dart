import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_lesson_video_player.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_bottom_action.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_module_section.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/lesson_player_quiz_cta.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_screen_mixin.dart';
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
    final size = MediaQuery.sizeOf(context);
    final orientation = MediaQuery.orientationOf(context);
    final playerHeight = size.width * 9 / 16;
    final isYoutube =
        lesson != null && isYoutubeLessonVideoUrl(lesson.videoUrl);
    // YouTube to'liq ekran landshaftda [YoutubePlayerBuilder] butun balandlikni talab qiladi.
    final headerExtent = isYoutube && orientation == Orientation.landscape
        ? size.height
        : playerHeight;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final showQuizCta =
        isRegistered &&
        lesson != null &&
        lesson.isCompleted &&
        lesson.hasQuiz &&
        !lesson.hasCompletedLessonQuiz;
    final showCompleteCta =
        isRegistered && lesson != null && !lesson.isCompleted;
    final hasBottomDock = showCompleteCta || showQuizCta;
    // To'liq ekran landshaftda pastki CTA videoni yoki boshqaruvni qoplaydi.
    final hideBottomDockForFullscreen =
        isYoutube && orientation == Orientation.landscape;
    final showBottomDock = hasBottomDock && !hideBottomDockForFullscreen;
    const double dockBarHeight = 56;
    final double scrollBottomPadding = showBottomDock
        ? 16 + dockBarHeight + bottomInset
        : 20;
    // BottomNav rasmi `Align`+`cover` bilan butun ekranni qoplayapti — faqat pastki qatlam.
    final bottomDecorationHeight = (size.height * 0.22).clamp(100.0, 180.0);
    final showBottomDecoration =
        lesson != null && !(isYoutube && orientation == Orientation.landscape);

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
                          extent: headerExtent,
                          lessonId: lesson.id,
                          videoUrl: lesson.videoUrl,
                          childBuilder: (context) => Stack(
                            fit: StackFit.expand,
                            children: [
                              buildVideoPlayer(context, lesson: lesson),
                              if (orientation != Orientation.landscape)
                                Positioned(
                                  left: 12,
                                  top: 12,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withValues(
                                        alpha: 0.35,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () => context.pop(),
                                      icon: const Icon(
                                        LucideIcons.chevronLeft,
                                        color: AppColors.white,
                                      ),
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
                                context.l10n.lessonProgress(
                                  lesson.order,
                                  args.course.lessonsCount,
                                ),
                                style: context.textTheme.bodySmallMedium
                                    .copyWith(
                                      color: AppColors.primary,
                                      letterSpacing: 0.2,
                                    ),
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
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  if (args.course.teacherAvatarUrl
                                      .trim()
                                      .isNotEmpty) ...[
                                    ClipOval(
                                      child: AppCachedNetworkImage(
                                        imageUrl: args.course.teacherAvatarUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        fallback:
                                            const AppNetworkImageFallbackAvatar(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Expanded(
                                    child: Text(
                                      args.course.teacherName,
                                      style: context.textTheme.bodySmallRegular
                                          .copyWith(
                                            color: context.appColors.grey,
                                            height: 1.35,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          scrollBottomPadding,
                        ),
                        sliver: SliverList.builder(
                          itemCount: modulesWithHydratedLessons.length,
                          itemBuilder: (context, index) {
                            final module = modulesWithHydratedLessons[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: CourseModuleSection(
                                module: module,
                                allModules: modulesWithHydratedLessons,
                                sequentialCurriculumEnabled:
                                    isRegistered && args.course.isEnrolled,
                                selectedLessonId: lesson.id,
                                onLessonTap: onLessonTap,
                                onOpenQuiz: isRegistered
                                    ? (id) => openLessonQuizFromPlayer(
                                        context,
                                        lessonId: id,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (showBottomDecoration)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: bottomDecorationHeight,
                      child: IgnorePointer(
                        child: context.isDarkTheme
                            ? UiKitAssets.images.bottomNavDark.image(
                                fit: BoxFit.cover,
                                width: size.width,
                                height: bottomDecorationHeight,
                              )
                            : UiKitAssets.images.bottomNavLight.image(
                                fit: BoxFit.cover,
                                width: size.width,
                                height: bottomDecorationHeight,
                              ),
                      ),
                    ),
                  if (showBottomDock)
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
                              onOpenQuiz: () => openLessonQuizFromPlayer(
                                context,
                                lessonId: lesson.id,
                              ),
                            ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _PinnedVideoHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedVideoHeaderDelegate({
    required this.extent,
    required this.lessonId,
    required this.videoUrl,
    required this.childBuilder,
  });

  final double extent;
  final String lessonId;
  final String? videoUrl;
  final Widget Function(BuildContext context) childBuilder;

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
    return ColoredBox(color: AppColors.black, child: childBuilder(context));
  }

  /// [Widget] ni solishtirmaymiz: har `setState` da yangi instance bo‘ladi va
  /// YouTube [WebView] har safar dispose bo‘lib iOS Pigeon `channel-error` beradi.
  @override
  bool shouldRebuild(covariant _PinnedVideoHeaderDelegate oldDelegate) {
    return oldDelegate.extent != extent ||
        oldDelegate.lessonId != lessonId ||
        oldDelegate.videoUrl != videoUrl;
  }
}
