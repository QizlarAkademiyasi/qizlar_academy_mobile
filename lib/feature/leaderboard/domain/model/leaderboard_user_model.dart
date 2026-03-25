import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Reytingdagi foydalanuvchi — API response bilan moslashtirish oson.
class LeaderboardUserModel extends Equatable {
  const LeaderboardUserModel({
    required this.id,
    required this.userCode,
    required this.fullName,
    required this.avatarUrl,
    required this.rank,
    required this.score,
    required this.courseName,
    required this.finishedCoursesCount,
    required this.certificatesCount,
    required this.followerCount,
    required this.rating,
  });

  final String id;
  /// API dan keladigan display id (masalan: "123456")
  final String userCode;
  final String fullName;
  final String avatarUrl;
  final int rank;
  final int score;
  final String courseName;
  final int finishedCoursesCount;
  final int certificatesCount;
  /// Ko'rsatish uchun matn (masalan "1.9k").
  final String followerCount;
  final double rating;

  @override
  List<Object?> get props => [
        id,
        userCode,
        fullName,
        avatarUrl,
        rank,
        score,
        courseName,
        finishedCoursesCount,
        certificatesCount,
        followerCount,
        rating,
      ];
}
