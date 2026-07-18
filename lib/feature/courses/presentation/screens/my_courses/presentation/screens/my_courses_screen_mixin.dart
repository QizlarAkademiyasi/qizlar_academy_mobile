import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/bloc/my_courses_bloc.dart';

mixin MyCoursesScreenMixin<T extends StatefulWidget> on State<T> {
  void myCoursesBlocListener(BuildContext context, MyCoursesState state) {
    if (!state.loadMoreFailed) return;
    AppToast.error(context, message: context.l10n.myCoursesLoadMoreError);
    context.read<MyCoursesBloc>().add(const MyCoursesLoadMoreFailureConsumed());
  }

  void onBackTap(BuildContext context) {
    context.pop();
  }

  void onCourseTap(BuildContext context, {required String courseId}) {
    context.push(Routes.courseDetails(courseId));
  }

  void onScrollNearEnd(BuildContext context) {
    context.read<MyCoursesBloc>().add(const MyCoursesLoadMoreRequested());
  }

  void retryFirstPage(BuildContext context) {
    context.read<MyCoursesBloc>().add(const MyCoursesRetryRequested());
  }

  Widget buildMyCourseListTile(
    BuildContext context, {
    required MyCoursesState state,
    required int index,
  }) {
    final course = state.courses[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCourseListItemCard(
        imageUrl: course.bannerImageUrl,
        title: course.name,
        mentorName: course.teacherFullname,
        rating: course.avgRating,
        reviewsCount: course.totalRatings,
        durationSeconds: course.totalDurationSeconds,
        titleMaxLines: 3,
        coverHeroCourseId: course.id,
        onTap: () => onCourseTap(context, courseId: course.id),
      ),
    );
  }
}
