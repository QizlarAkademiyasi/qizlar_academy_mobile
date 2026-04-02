import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseSubmitReviewArgs extends Equatable {
  const CourseSubmitReviewArgs({
    required this.courseId,
    required this.title,
    required this.categoryName,
    required this.teacherName,
    required this.thumbnailUrl,
    this.onSubmitted,
  });

  final String courseId;
  final String title;
  final String categoryName;
  final String teacherName;
  final String thumbnailUrl;

  /// Muvaffaqiyatdan keyin (pop dan oldin) — masalan [CourseDetailsBloc] ga optimistik sharh.
  final void Function(double rating, String comment)? onSubmitted;

  @override
  List<Object?> get props => [courseId, title, categoryName, teacherName, thumbnailUrl];
}
