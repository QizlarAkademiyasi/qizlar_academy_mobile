import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_list_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_in_progress_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_search_field.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

part 'courses_search_screen_mixin.dart';

class CoursesSearchScreen extends StatelessWidget {
  const CoursesSearchScreen({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return CoursesSearchView(initialQuery: initialQuery);
  }
}

class CoursesSearchView extends StatefulWidget {
  const CoursesSearchView({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<CoursesSearchView> createState() => _CoursesSearchViewState();
}

class _CoursesSearchViewState extends State<CoursesSearchView>
    with CoursesSearchScreenMixin {
  Object _searchStaggerScrollKey(CoursesCatalogState state) {
    final o = state.overview;
    if (o == null) {
      return ValueKey<String>(
        'courses_search_${state.status.name}_${state.query}',
      );
    }
    return ObjectKey(o);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: '',
      backgroundColor: context.theme.scaffoldBackgroundColor,
      showBackButton: false,
      titleWidget: buildSearchHeroField(context, forAppBar: true),
      actions: [
        AppBackButton(
          onTap: () => onSearchDismiss(context),
          icon: Icons.close_rounded,
          tooltip: context.l10n.courseCompleteClose,
        ),
        const SizedBox(width: 8),
      ],
      body: BlocConsumer<CoursesCatalogBloc, CoursesCatalogState>(
        listener: coursesSearchBlocListener,
        builder: (context, state) {
          final isInitialLoading =
              (state.status == CoursesCatalogStatus.loading ||
                  state.status == CoursesCatalogStatus.initial) &&
              !state.hasData;

          return AppStaggeredScrollLimiter(
            key: ValueKey(_searchStaggerScrollKey(state)),
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => onSearchPullRefresh(context),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    ..._searchBodySlivers(context, state, isInitialLoading),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _searchBodySlivers(
    BuildContext context,
    CoursesCatalogState state,
    bool isInitialLoading,
  ) {
    final queryTrimmed = searchController.text.trim();
    if (queryTrimmed.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: TgsEmptyContent(
                message: context.l10n.coursesSearchIdleHint,
                animationSize: 92,
              ),
            ),
          ),
        ),
      ];
    }

    if (state.status == CoursesCatalogStatus.failure && !state.hasData) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: TgsFailureContent(
            message: context.l10n.coursesCatalogLoadError,
            onRetry: () => onSearchRetry(context),
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
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 8),
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
                    buildSearchInProgressCard(context, lastViewed),
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
                child: buildSearchCourseCard(context, courses[courseIndex]),
              ),
            );
          }, childCount: itemCount),
        ),
      ),
    ];
  }
}
