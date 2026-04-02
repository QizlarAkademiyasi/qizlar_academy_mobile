part of 'course_submit_review_bloc.dart';

enum CourseSubmitReviewStatus { initial, submitting, success, failure }

class CourseSubmitReviewState extends Equatable {
  const CourseSubmitReviewState({
    this.status = CourseSubmitReviewStatus.initial,
    this.message,
  });

  final CourseSubmitReviewStatus status;
  final String? message;

  CourseSubmitReviewState copyWith({
    CourseSubmitReviewStatus? status,
    String? message,
    bool clearMessage = false,
  }) {
    return CourseSubmitReviewState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, message];
}
