import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/data/datasource/courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';

class CoursesApiDatasource implements CoursesDatasource {
  const CoursesApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId}) async {
    final response = await _dio.get<dynamic>(Apis.courseDetails(courseId));
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Course details response should be an object');
    }
    final map = data.map((key, value) => MapEntry(key.toString(), value));
    return CourseDetailsModel(
      id: (map['id'] ?? courseId).toString(),
      title: (map['title'] ?? '').toString(),
      teacherName: (map['teacher_name'] ?? map['teacherName'] ?? '').toString(),
      teacherRole: (map['teacher_role'] ?? map['teacherRole'] ?? '').toString(),
      coverImageUrl: (map['cover_image_url'] ?? map['coverImageUrl'] ?? '').toString(),
      teacherAvatarUrl:
          (map['teacher_avatar_url'] ?? map['teacherAvatarUrl'] ?? '').toString(),
      rating: (map['rating'] ?? 0).toString().parseDoubleSafe(),
      reviewsCount: (map['reviews_count'] ?? map['reviewsCount'] ?? 0)
          .toString()
          .parseIntSafe(),
      studentsCount: (map['students_count'] ?? map['studentsCount'] ?? 0)
          .toString()
          .parseIntSafe(),
      totalDurationText:
          (map['total_duration_text'] ?? map['totalDurationText'] ?? '')
              .toString(),
      lessonsCount:
          (map['lessons_count'] ?? map['lessonsCount'] ?? 0).toString().parseIntSafe(),
      progressRatio:
          (map['progress_ratio'] ?? map['progressRatio'] ?? 0).toString().parseDoubleSafe(),
      progressLessonsText:
          (map['progress_lessons_text'] ?? map['progressLessonsText'] ?? '')
              .toString(),
      progressSeenText:
          (map['progress_seen_text'] ?? map['progressSeenText'] ?? '').toString(),
      progressDurationText:
          (map['progress_duration_text'] ?? map['progressDurationText'] ?? '')
              .toString(),
      description: (map['description'] ?? '').toString(),
      teacherDescription:
          (map['teacher_description'] ?? map['teacherDescription'] ?? '')
              .toString(),
      ratingBreakdown: const [],
      reviews: const [],
      modules: const [],
    );
  }
}

extension on String {
  int parseIntSafe() => int.tryParse(this) ?? 0;
  double parseDoubleSafe() => double.tryParse(this) ?? 0;
}
