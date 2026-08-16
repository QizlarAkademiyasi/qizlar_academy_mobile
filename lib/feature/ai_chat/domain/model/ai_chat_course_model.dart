import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class AiChatCourseModel extends Equatable {
  const AiChatCourseModel({
    required this.id,
    required this.title,
    required this.mentorName,
    required this.imageUrl,
    this.rating,
    this.durationSeconds,
    this.reason,
  });

  final String id;
  final String title;
  final String mentorName;
  final String imageUrl;
  final double? rating;
  final int? durationSeconds;
  final String? reason;

  @override
  List<Object?> get props => [
    id,
    title,
    mentorName,
    imageUrl,
    rating,
    durationSeconds,
    reason,
  ];
}
