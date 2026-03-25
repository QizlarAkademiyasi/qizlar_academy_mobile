import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_bottom_action.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_details_sliver_header.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_details_content_mixin.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_meta_row.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_tabs.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

/// Kurs detallari ekranining asosiy kontenti: header, meta, tablar, tab kontenti, pastki CTA.
/// SOLID: bitta javobgarlik — faqat shu layout va child komponentlarni boshqaradi.
class CourseDetailsContent extends StatelessWidget
    with CourseDetailsContentMixin {
  const CourseDetailsContent({
    super.key,
    required this.course,
    required this.selectedTab,
    required this.onTabChanged,
    this.onContinueTap,
    this.onLessonTap,
  });

  final CourseDetailsModel course;
  final CoursesTab selectedTab;
  final ValueChanged<CoursesTab> onTabChanged;
  final VoidCallback? onContinueTap;
  final ValueChanged<String>? onLessonTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CourseDetailsSliverHeader(course: course),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      CourseMetaRow(course: course),
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
                        selected: selectedTab,
                        onChanged: onTabChanged,
                        lessonsCount: course.lessonsCount,
                        reviewsCount: course.reviewsCount,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 96 + bottomInset,
                ),
                sliver: SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: buildTabContent(
                      context,
                      selectedTab: selectedTab,
                      course: course,
                      onLessonTap: onLessonTap,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomInset,
            child: CourseBottomAction(
              label: selectedTab == CoursesTab.info
                  ? "Kursga yozilish"
                  : 'Davom etish',
              showLeadingIcon: selectedTab != CoursesTab.info,
              onTap: onContinueTap ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedCourseTabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedCourseTabsHeaderDelegate({
    required this.child,
    required this.minExtentHeight,
    required this.maxExtentHeight,
  });

  final Widget child;
  final double minExtentHeight;
  final double maxExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedCourseTabsHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtentHeight != minExtentHeight ||
        oldDelegate.maxExtentHeight != maxExtentHeight;
  }
}
