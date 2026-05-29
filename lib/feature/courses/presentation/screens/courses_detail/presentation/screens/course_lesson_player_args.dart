import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';

class CourseLessonPlayerArgs {
  const CourseLessonPlayerArgs({required this.course, this.initialLessonId});

  final CourseDetailsModel course;
  final String? initialLessonId;
}
