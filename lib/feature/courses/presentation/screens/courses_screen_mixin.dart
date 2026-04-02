import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/bloc/courses_catalog_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_in_progress_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_search_field.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/components/courses_top_bar.dart';

mixin CoursesScreenMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void coursesBlocListener(BuildContext context, CoursesCatalogState state) {
    if (state.status != CoursesCatalogStatus.failure || state.message == null) {
      return;
    }
    AppToast.error(context, message: state.message!);
  }

  void onSearchChanged(BuildContext context, String value) {
    context.read<CoursesCatalogBloc>().add(CoursesCatalogSearchChanged(query: value));
  }

  void onNotificationTap(BuildContext context) {
    AppToast.info(context, title: context.l10n.comingSoonTitle, message: context.l10n.coursesNotificationsComingSoonMessage);
  }

  void openCourseDetails(BuildContext context, String courseId) {
    context.push(Routes.courseDetails(courseId));
  }

  void retry(BuildContext context) {
    context.read<CoursesCatalogBloc>().add(const CoursesCatalogRetryRequested());
  }

  Widget buildTopBar(BuildContext context) {
    return CoursesTopBar(onNotificationTap: () => onNotificationTap(context));
  }

  Widget buildSearchField(BuildContext context) {
    return CoursesSearchField(controller: searchController, onChanged: (value) => onSearchChanged(context, value));
  }

  Widget buildInProgressCard(BuildContext context, CourseInProgressModel model) {
    return CoursesInProgressCard(course: model, onTap: () => openCourseDetails(context, model.courseId));
  }

  Widget buildCourseCard(BuildContext context, CourseCatalogItemModel model) {
    return AppCourseListItemCard(
      imageUrl: model.imageUrl,
      title: model.title,
      mentorName: model.mentorName,
      rating: model.rating,
      reviewsCount: model.reviewsCount,
      durationHours: model.durationHours,
      tagLabel: model.tagLabel,
      onTap: () => openCourseDetails(context, model.id),
    );
  }
}
