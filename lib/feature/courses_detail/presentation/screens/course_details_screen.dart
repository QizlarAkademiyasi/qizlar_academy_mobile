import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/courses_page_loading_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/bloc/course_details_bloc.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_details_screen_mixin.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key, this.courseId});

  final String? courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseDetailsBloc>()
        ..add(
          CoursesCourseDetailsRequested(courseId: courseId ?? 'marketolog'),
        ),
      child: const _CoursesView(),
    );
  }
}

class _CoursesView extends StatefulWidget {
  const _CoursesView();

  @override
  State<_CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<_CoursesView>
    with CourseDetailsScreenMixin<_CoursesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<CourseDetailsBloc, CourseDetailsState>(
        listener: coursesBlocListener,
        builder: (context, state) {
          final hasCourse = state.course != null;
          final isFirstLoad =
              !hasCourse &&
              (state.status == CoursesStatus.initial ||
                  state.status == CoursesStatus.loading);

          if (isFirstLoad) {
            return const CoursesPageLoadingSkeleton();
          }

          if (state.status == CoursesStatus.failure && !hasCourse) {
            return TgsFailureContent(
              message: state.message,
              onRetry: () => retryLoad(context),
            );
          }

          if (!hasCourse) {
            return const SizedBox.shrink();
          }

          return buildCourseDetails(context, course: state.course!);
        },
      ),
    );
  }
}
