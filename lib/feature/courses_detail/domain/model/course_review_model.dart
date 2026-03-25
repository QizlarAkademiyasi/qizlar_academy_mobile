import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseReviewModel extends Equatable {
  const CourseReviewModel({
    required this.id,
    required this.userName,
    required this.userInitials,
    required this.timeAgo,
    required this.rating,
    required this.comment,
  });

  final String id;
  final String userName;
  final String userInitials;
  final String timeAgo;
  final int rating;
  final String comment;

  @override
  List<Object?> get props => [id, userName, userInitials, timeAgo, rating, comment];
}

class CourseRatingBreakdownModel extends Equatable {
  const CourseRatingBreakdownModel({
    required this.stars,
    required this.percent,
  });

  final int stars;
  final int percent;

  @override
  List<Object?> get props => [stars, percent];
}

