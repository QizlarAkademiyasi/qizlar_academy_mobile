part of 'course_submit_review_bloc.dart';

sealed class CourseSubmitReviewEvent extends Equatable {
  const CourseSubmitReviewEvent();

  @override
  List<Object?> get props => [];
}

final class CourseSubmitReviewSubmitted extends CourseSubmitReviewEvent {
  const CourseSubmitReviewSubmitted({required this.rating, required this.comment});

  final double rating;
  final String comment;

  @override
  List<Object?> get props => [rating, comment];
}
