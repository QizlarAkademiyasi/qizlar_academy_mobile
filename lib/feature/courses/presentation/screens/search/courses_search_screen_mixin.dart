part of 'courses_search_screen.dart';

mixin CoursesSearchScreenMixin on State<CoursesSearchView> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void coursesSearchBlocListener(BuildContext context, CoursesCatalogState state) {
    if (state.status != CoursesCatalogStatus.failure || !state.hasData) {
      return;
    }
    AppToast.error(context, message: context.l10n.coursesCatalogLoadError);
  }

  void onSearchChanged(BuildContext context, String value) {
    context.read<CoursesCatalogBloc>().add(CoursesCatalogSearchChanged(query: value));
  }

  void onSearchDismiss(BuildContext context) {
    context.pop();
  }

  void onSearchOpenCourse(BuildContext context, String courseId) {
    context.push(Routes.courseDetails(courseId));
  }

  void onSearchRetry(BuildContext context) {
    context.read<CoursesCatalogBloc>().add(const CoursesCatalogRetryRequested());
  }

  Future<void> onSearchPullRefresh(BuildContext context) async {
    final bloc = context.read<CoursesCatalogBloc>();
    bloc.add(const CoursesCatalogRefreshRequested());
    await bloc.stream.firstWhere((s) => !s.isRefreshing);
  }

  Widget buildSearchHeroField(BuildContext context, {bool forAppBar = false}) {
    return CoursesSearchField(
      controller: searchController,
      autofocus: true,
      onChanged: (value) => onSearchChanged(context, value),
      heroTag: CoursesSearchField.kHeroTag,
      padding: forAppBar ? EdgeInsets.zero : null,
    );
  }

  Widget buildSearchInProgressCard(BuildContext context, CourseInProgressModel model) {
    return CoursesInProgressCard(course: model, onTap: () => onSearchOpenCourse(context, model.courseId));
  }

  Widget buildSearchCourseCard(BuildContext context, CourseCatalogItemModel model) {
    return AppCourseListItemCard(
      imageUrl: model.imageUrl,
      title: model.title,
      mentorName: model.mentorName,
      rating: model.rating,
      reviewsCount: model.reviewsCount,
      durationSeconds: model.durationSeconds,
      tagLabel: model.tagLabel,
      onTap: () => onSearchOpenCourse(context, model.id),
    );
  }
}
