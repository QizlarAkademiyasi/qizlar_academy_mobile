import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';

abstract class CoursesRepository {
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId});

  /// [courseId] berilsa, `GET /api/v1/course/{courseId}/module/{lessonId}` (yangilangan dars kartasi).
  Future<CourseLessonModel> fetchLessonDetails({required String lessonId, String? courseId});

  Future<void> completeLesson({required String lessonId});

  /// Faqat ro‘yxatdan o‘tgan foydalanuvchi (`UserType.user`).
  Future<void> enrollInCourse({required String courseId});

  /// Kursga sharh / reyting yuborish (`POST /api/v1/course-rating`).
  Future<void> submitCourseRating({required String courseId, required double rating, required String comment});
}
