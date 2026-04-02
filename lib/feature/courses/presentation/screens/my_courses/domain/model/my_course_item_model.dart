import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// `/api/v1/course/my` ro'yxatidagi bitta kurs.
class MyCourseItemModel extends Equatable {
  const MyCourseItemModel({
    required this.id,
    required this.name,
    required this.bannerImageUrl,
    required this.teacherFullname,
    required this.enrollmentCount,
    required this.totalDurationHours,
    required this.avgRating,
    required this.totalRatings,
  });

  final String id;
  final String name;
  final String bannerImageUrl;
  final String teacherFullname;
  final int enrollmentCount;
  final int totalDurationHours;
  final double avgRating;
  final int totalRatings;

  @override
  List<Object?> get props => [
    id,
    name,
    bannerImageUrl,
    teacherFullname,
    enrollmentCount,
    totalDurationHours,
    avgRating,
    totalRatings,
  ];
}
