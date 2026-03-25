import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseLessonModel extends Equatable {
  const CourseLessonModel({
    required this.id,
    required this.order,
    required this.title,
    required this.duration,
    required this.isLocked,
    required this.isCompleted,
    this.videoUrl,
  });

  final String id;
  final int order;
  final String title;

  /// UI uchun tayyor ko‘rinish (masalan: "12:30" yoki "08:45").
  final String duration;

  final bool isLocked;
  final bool isCompleted;
  final String? videoUrl;

  @override
  List<Object?> get props => [
    id,
    order,
    title,
    duration,
    isLocked,
    isCompleted,
    videoUrl,
  ];
}

