import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class TeacherModel extends Equatable {
  const TeacherModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.coursesCount,
  });

  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final int coursesCount;

  @override
  List<Object?> get props => [id, name, specialty, imageUrl, coursesCount];
}
