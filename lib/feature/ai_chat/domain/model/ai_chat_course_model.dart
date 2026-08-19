import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class AiChatCourseModel extends Equatable {
  const AiChatCourseModel({
    required this.id,
    required this.title,
    required this.mentorName,
    required this.imageUrl,
    this.rating,
    this.totalRatings,
    this.durationMinutes,
    this.lessonCount,
    this.studentCount,
  });

  final String id;
  final String title;
  final String mentorName;
  final String imageUrl;
  final double? rating;
  final int? totalRatings;
  final int? durationMinutes;
  final int? lessonCount;
  final int? studentCount;

  @override
  List<Object?> get props => [
    id,
    title,
    mentorName,
    imageUrl,
    rating,
    totalRatings,
    durationMinutes,
    lessonCount,
    studentCount,
  ];
}
