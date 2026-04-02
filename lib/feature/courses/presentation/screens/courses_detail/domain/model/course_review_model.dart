import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class CourseReviewModel extends Equatable {
  const CourseReviewModel({
    required this.id,
    required this.userName,
    required this.userInitials,
    this.createdAt,
    required this.rating,
    required this.commentHtml,
  });

  final String id;
  final String userName;
  final String userInitials;
  final DateTime? createdAt;
  final int rating;
  /// Backenddan keladigan HTML (masalan `<p>...</p>`).
  final String commentHtml;

  @override
  List<Object?> get props => [
    id,
    userName,
    userInitials,
    createdAt,
    rating,
    commentHtml,
  ];
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
