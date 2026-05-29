import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class ProfileUserPublicModel extends Equatable {
  const ProfileUserPublicModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.rating,
    required this.certificateCount,
    required this.enrolledCourseCount,
    required this.badge,
  });

  final String id;
  final String firstname;
  final String lastname;
  final int rating;
  final int certificateCount;
  final int enrolledCourseCount;
  final int badge;

  String get fullName => '${firstname.trim()} ${lastname.trim()}'.trim();

  @override
  List<Object?> get props => [
        id,
        firstname,
        lastname,
        rating,
        certificateCount,
        enrolledCourseCount,
        badge,
      ];
}

