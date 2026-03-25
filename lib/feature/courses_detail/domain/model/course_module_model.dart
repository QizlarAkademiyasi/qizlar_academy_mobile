import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_lesson_model.dart';

class CourseModuleModel extends Equatable {
  const CourseModuleModel({
    required this.id,
    required this.title,
    required this.progressText,
    required this.totalDurationText,
    required this.lessons,
    this.isExpandedByDefault = true,
  });

  final String id;
  final String title;

  /// UI uchun: "2/10 dars - 38 min"
  final String progressText;

  /// UI uchun: "3s 22m umumiy"
  final String totalDurationText;

  final List<CourseLessonModel> lessons;
  final bool isExpandedByDefault;

  @override
  List<Object?> get props => [
    id,
    title,
    progressText,
    totalDurationText,
    lessons,
    isExpandedByDefault,
  ];
}
