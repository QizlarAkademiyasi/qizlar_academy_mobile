import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/constants/app_share_links.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/course_curriculum_progress.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_bottom_action.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_details_sliver_header.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_details_content_mixin.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_meta_row.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_tabs.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

/// Kurs detallari: [NestedScrollView] + [TabBarView] (silliq siljitish, sliver bilan ziddiyatsiz).
class CourseDetailsContent extends StatefulWidget {
  const CourseDetailsContent({
    super.key,
    required this.course,
    required this.selectedTab,
    required this.onTabChanged,
    required this.isEnrolling,
    required this.onPrimaryCtaTap,
    required this.onLeaveReviewTap,
    this.onLessonTap,
    this.onOpenQuiz,
  });

  final CourseDetailsModel course;
  final CoursesTab selectedTab;
  final ValueChanged<CoursesTab> onTabChanged;
  final bool isEnrolling;
  final VoidCallback onPrimaryCtaTap;

  /// «Sharhlar» tabida, yozilgan foydalanuvchi uchun pastdagi asosiy tugma.
  final VoidCallback onLeaveReviewTap;
  final ValueChanged<String>? onLessonTap;
  final void Function(String lessonId)? onOpenQuiz;

  @override
  State<CourseDetailsContent> createState() => _CourseDetailsContentState();
}

class _CourseDetailsContentState extends State<CourseDetailsContent> with TickerProviderStateMixin, CourseDetailsContentMixin {
  static const int _tabCount = 3;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final i = widget.selectedTab.index.clamp(0, _tabCount - 1);
    _tabController = TabController(length: _tabCount, vsync: this, initialIndex: i);
    _tabController.addListener(_onTabControllerChanged);
  }

  void _onTabControllerChanged() {
    if (!mounted) return;
    if (_tabController.indexIsChanging) return;
    widget.onTabChanged(CoursesTab.values[_tabController.index]);
  }

  @override
  void didUpdateWidget(CourseDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTab != widget.selectedTab) {
      final i = widget.selectedTab.index.clamp(0, _tabCount - 1);
      if (_tabController.index != i) {
        _tabController.animateTo(i);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabControllerChanged);
    _tabController.dispose();
    super.dispose();
  }

  bool get _showPlayLeadingIcon {
    final session = getIt<AuthSessionCubit>().state;
    if (session.isAnonymous) return false;
    return widget.course.isEnrolled;
  }

  bool get _courseFullyComplete => CourseCurriculumProgress.isCourseFullyComplete(widget.course.modules);

  bool get _showCertificatePrimaryCta {
    final session = getIt<AuthSessionCubit>().state;
    return session.isRegistered && widget.course.isEnrolled && _courseFullyComplete;
  }

  String _primaryCtaLabel(BuildContext context) {
    final session = getIt<AuthSessionCubit>().state;
    final l10n = context.l10n;
    if (session.isAnonymous) {
      return l10n.courseGuestFirstLessonCta;
    }
    if (!widget.course.isEnrolled) {
      return l10n.courseEnroll;
    }
    if (_showCertificatePrimaryCta) {
      return l10n.courseCompleteGetCertificate;
    }
    return l10n.courseContinue;
  }

  bool get _reviewsTabLeaveReviewCta {
    final session = getIt<AuthSessionCubit>().state;
    return widget.selectedTab == CoursesTab.reviews && widget.course.isEnrolled && session.isRegistered;
  }

  String _bottomDockLabel(BuildContext context) {
    if (_reviewsTabLeaveReviewCta) return context.l10n.courseLeaveReviewCta;
    return _primaryCtaLabel(context);
  }

  VoidCallback get _bottomDockOnTap {
    if (_reviewsTabLeaveReviewCta) return widget.onLeaveReviewTap;
    return widget.onPrimaryCtaTap;
  }

  bool get _bottomDockShowPlayIcon {
    if (_reviewsTabLeaveReviewCta) return false;
    if (_showCertificatePrimaryCta) return true;
    return _showPlayLeadingIcon;
  }

  IconData? get _bottomDockLeadingIcon {
    if (_reviewsTabLeaveReviewCta) return null;
    if (_showCertificatePrimaryCta) return LucideIcons.fileBadge;
    return null;
  }

  Future<void> _onShareCourse() async {
    if (!mounted) return;
    final url = AppShareLinks.courseDetailsHttpsUrl(widget.course.id);
    final text = context.l10n.courseDetailsShareMessage(widget.course.title, url);
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Widget _tabScrollable({required CoursesTab tab, required EdgeInsets padding, required Widget child}) {
    return AppStaggeredScrollLimiter(
      key: ValueKey<String>('course_detail_tab_${identityHashCode(widget.course)}_${tab.name}'),
      child: CustomScrollView(
        key: PageStorageKey<String>('course_details_${widget.course.id}_${tab.name}'),
        primary: true,
        slivers: [
          SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(child: child),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom + 24;
    final session = getIt<AuthSessionCubit>().state;
    final lessonsLockedUntilEnroll = session.isRegistered && !widget.course.isEnrolled;
    final guestPreviewLessonId = session.isAnonymous ? widget.course.firstGuestPreviewLessonId : null;
    final curriculumHighlightLessonId = widget.course.curriculumHighlightLessonId(isAnonymous: session.isAnonymous, guestPreviewLessonId: guestPreviewLessonId);
    void onGuestLessonAuthRequired() {
      showAuthRequiredBottomSheet(context, title: context.l10n.courseGuestMoreLessonsTitle, description: context.l10n.courseGuestMoreLessonsBody);
    }

    final tabBottomPad = 96.0 + bottomInset;
    final horizontalPad = 20.0;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          AppStaggeredScrollLimiter(
            key: ObjectKey(widget.course),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  CourseDetailsSliverHeader(
                    course: widget.course,
                    onShareTap: _onShareCourse,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          AppStaggeredListItem(
                            position: 1,
                            duration: AppStaggeredListAnimation.duration,
                            delay: AppStaggeredListAnimation.staggerDelay,
                            verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
                            child: CourseMetaRow(course: widget.course),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PinnedCourseTabsHeaderDelegate(
                      minExtentHeight: 85,
                      maxExtentHeight: 85,
                      courseId: widget.course.id,
                      brightness: Theme.of(context).brightness,
                      locale: Localizations.localeOf(context),
                      tabController: _tabController,
                      lessonsCount: widget.course.lessonsCount,
                      reviewsCount: widget.course.reviewsCount,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _tabScrollable(
                    tab: CoursesTab.lessons,
                    padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, tabBottomPad),
                    child: buildTabPage(
                      context,
                      CoursesTab.lessons,
                      onLessonTap: widget.onLessonTap,
                      onOpenQuiz: widget.onOpenQuiz,
                      lessonsLockedUntilEnroll: lessonsLockedUntilEnroll,
                      guestPreviewLessonId: guestPreviewLessonId,
                      onGuestLessonAuthRequired: guestPreviewLessonId != null ? onGuestLessonAuthRequired : null,
                      selectedCurriculumLessonId: curriculumHighlightLessonId,
                    ),
                  ),
                  _tabScrollable(tab: CoursesTab.info, padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, tabBottomPad), child: buildTabPage(context, CoursesTab.info)),
                  _tabScrollable(tab: CoursesTab.reviews, padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, tabBottomPad), child: buildTabPage(context, CoursesTab.reviews)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: context.isDarkTheme ? UiKitAssets.images.bottomNavDark.image(fit: BoxFit.cover) : UiKitAssets.images.bottomNavLight.image(fit: BoxFit.cover),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomInset,
            child: CourseBottomAction(
              label: _bottomDockLabel(context),
              showLeadingIcon: _bottomDockShowPlayIcon,
              leadingIcon: _bottomDockLeadingIcon,
              enabled: !widget.isEnrolling,
              onTap: _bottomDockOnTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedCourseTabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedCourseTabsHeaderDelegate({
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.courseId,
    required this.brightness,
    required this.locale,
    required this.tabController,
    required this.lessonsCount,
    required this.reviewsCount,
  });

  final double minExtentHeight;
  final double maxExtentHeight;
  final String courseId;
  final Brightness brightness;
  final Locale locale;
  final TabController tabController;
  final int lessonsCount;
  final int reviewsCount;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Padding(
          padding: AppPadding.paddingVerticalSm,
          child: CourseTabs(controller: tabController, lessonsCount: lessonsCount, reviewsCount: reviewsCount),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedCourseTabsHeaderDelegate oldDelegate) {
    return oldDelegate.minExtentHeight != minExtentHeight ||
        oldDelegate.maxExtentHeight != maxExtentHeight ||
        oldDelegate.courseId != courseId ||
        oldDelegate.brightness != brightness ||
        oldDelegate.locale != locale ||
        oldDelegate.tabController != tabController ||
        oldDelegate.lessonsCount != lessonsCount ||
        oldDelegate.reviewsCount != reviewsCount;
  }
}
