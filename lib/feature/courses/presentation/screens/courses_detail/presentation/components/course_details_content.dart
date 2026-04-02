import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
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

  String _primaryCtaLabel(BuildContext context) {
    final session = getIt<AuthSessionCubit>().state;
    final l10n = context.l10n;
    if (session.isAnonymous) {
      return l10n.courseGuestFirstLessonCta;
    }
    if (!widget.course.isEnrolled) {
      return l10n.courseEnroll;
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
    return _showPlayLeadingIcon;
  }

  Widget _tabScrollable({
    required CoursesTab tab,
    required EdgeInsets padding,
    required Widget child,
  }) {
    return CustomScrollView(
      key: PageStorageKey<String>('course_details_${widget.course.id}_${tab.name}'),
      primary: true,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(child: child),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final session = getIt<AuthSessionCubit>().state;
    final lessonsLockedUntilEnroll = session.isRegistered && !widget.course.isEnrolled;
    final guestPreviewLessonId = session.isAnonymous ? widget.course.firstGuestPreviewLessonId : null;
    void onGuestLessonAuthRequired() {
      showAuthRequiredBottomSheet(context, title: context.l10n.courseGuestMoreLessonsTitle, description: context.l10n.courseGuestMoreLessonsBody);
    }

    final tabBottomPad = 96.0 + bottomInset;
    final horizontalPad = 20.0;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CourseDetailsSliverHeader(course: widget.course),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        CourseMetaRow(course: widget.course),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedCourseTabsHeaderDelegate(
                    minExtentHeight: 85,
                    maxExtentHeight: 85,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Padding(
                        padding: AppPadding.paddingVerticalSm,
                        child: CourseTabs(
                          controller: _tabController,
                          lessonsCount: widget.course.lessonsCount,
                          reviewsCount: widget.course.reviewsCount,
                        ),
                      ),
                    ),
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
                  ),
                ),
                _tabScrollable(
                  tab: CoursesTab.info,
                  padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, tabBottomPad),
                  child: buildTabPage(context, CoursesTab.info),
                ),
                _tabScrollable(
                  tab: CoursesTab.reviews,
                  padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, tabBottomPad),
                  child: buildTabPage(context, CoursesTab.reviews),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomInset,
            child: CourseBottomAction(
              label: _bottomDockLabel(context),
              showLeadingIcon: _bottomDockShowPlayIcon,
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
  _PinnedCourseTabsHeaderDelegate({required this.child, required this.minExtentHeight, required this.maxExtentHeight});

  final Widget child;
  final double minExtentHeight;
  final double maxExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedCourseTabsHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.minExtentHeight != minExtentHeight || oldDelegate.maxExtentHeight != maxExtentHeight;
  }
}
