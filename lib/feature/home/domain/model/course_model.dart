import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseModel extends Equatable {
  const CourseModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.durationHours,
    required this.studentCount,
  });

  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final int durationHours;
  final int studentCount;

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    imageUrl,
    durationHours,
    studentCount,
  ];
}
