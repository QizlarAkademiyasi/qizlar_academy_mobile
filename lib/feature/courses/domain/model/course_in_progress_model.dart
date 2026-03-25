import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseInProgressModel extends Equatable {
  const CourseInProgressModel({
    required this.courseId,
    required this.title,
    required this.moduleTitle,
    required this.imageUrl,
    required this.progressPercent,
    required this.progressLabel,
    required this.actionLabel,
  });

  final String courseId;
  final String title;
  final String moduleTitle;
  final String imageUrl;
  final int progressPercent;
  final String progressLabel;
  final String actionLabel;

  @override
  List<Object?> get props => [
    courseId,
    title,
    moduleTitle,
    imageUrl,
    progressPercent,
    progressLabel,
    actionLabel,
  ];
}
