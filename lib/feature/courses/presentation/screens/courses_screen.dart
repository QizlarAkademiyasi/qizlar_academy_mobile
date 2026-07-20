import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [CoursesCatalogBloc] [app_routes] dagi katalog route orqali beriladi.
    return const _CoursesView();
  }
}

class _CoursesView extends StatefulWidget {
  const _CoursesView();

  @override
  State<_CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<_CoursesView>
    with CoursesScreenMixin<_CoursesView> {
  /// [AnimationLimiter] birinchi frame dan keyin animatsiyani o‘chiradi; skeletondan keyin
  /// ro‘yxat chiqishi uchun limiter yangi [ObjectKey] bilan yaratilishi kerak.
  /// API har safar yangi [overview] instansiyasi qaytargach, qidiruv tugaganda ham stagger ishlaydi.
  Object _coursesStaggerScrollKey(CoursesCatalogState state) {
    final o = state.overview;
    if (o == null) {
      return ValueKey<String>('courses_${state.status.name}');
    }
    return ObjectKey(o);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<CoursesCatalogBloc, CoursesCatalogState>(
          listener: coursesBlocListener,
          builder: (context, state) {
            final isInitialLoading =
                (state.status == CoursesCatalogStatus.loading ||
                    state.status == CoursesCatalogStatus.initial) &&
                !state.hasData;

            // [AnimationLimiter] birinchi frame dan keyin animatsiyani o‘chiradi. Avval skeleton,
            // keyin ro‘yxat chiqsa kartalar animatsiyasiz qoladi — limiter shu kalit bilan
            // muvaffaqiyatli yuklanganda qayta yaratiladi.
            return AppStaggeredScrollLimiter(
              key: ValueKey(_coursesStaggerScrollKey(state)),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => onPullRefresh(context),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(child: buildTopBar(context)),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _CoursesPinnedSearchDelegate(
                        backgroundColor: context.theme.scaffoldBackgroundColor,
                        child: buildSearchField(context),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 14)),
                    ..._coursesBodySlivers(context, state, isInitialLoading),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _coursesBodySlivers(
    BuildContext context,
    CoursesCatalogState state,
    bool isInitialLoading,
  ) {
    if (state.status == CoursesCatalogStatus.failure && !state.hasData) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: TgsFailureContent(
            message: context.l10n.coursesCatalogLoadError,
            onRetry: () => retry(context),
          ),
        ),
      ];
    }

    if (isInitialLoading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: CoursesListSkeleton(),
        ),
      ];
    }

    final overview = state.overview;
    if (overview == null || overview.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: TgsEmptyContent(
                message: context.l10n.coursesNoResults,
                animationSize: 92,
              ),
            ),
          ),
        ),
      ];
    }

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final lastViewed = overview.lastViewedCourse;
    final hasInProgress = lastViewed != null;
    final courses = overview.courses;
    final itemCount = (hasInProgress ? 1 : 0) + courses.length;

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 48),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (hasInProgress && index == 0) {
              return AppStaggeredListItem(
                position: 0,
                duration: AppStaggeredListAnimation.duration,
                delay: AppStaggeredListAnimation.staggerDelay,
                verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildInProgressCard(context, lastViewed),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }
            final courseIndex = hasInProgress ? index - 1 : index;
            final staggerPosition = index;
            return AppStaggeredListItem(
              position: staggerPosition,
              duration: AppStaggeredListAnimation.duration,
              delay: AppStaggeredListAnimation.staggerDelay,
              verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: buildCourseCard(context, courses[courseIndex]),
              ),
            );
          }, childCount: itemCount),
        ),
      ),
    ];
  }
}

/// Kurslar qidiruv maydoni — scroll qilganda yuqorida qotib turadi.
class _CoursesPinnedSearchDelegate extends SliverPersistentHeaderDelegate {
  _CoursesPinnedSearchDelegate({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  /// [CoursesSearchField] (TextField + gorizontal padding) balandligi bilan mos.
  static const double _height = 62;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: SizedBox(
        height: _height,
        child: Center(child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CoursesPinnedSearchDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.child != child;
  }
}
