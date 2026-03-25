part of 'course_details_bloc.dart';

enum CoursesStatus { initial, loading, success, failure }

class CourseDetailsState extends Equatable {
  const CourseDetailsState({
    this.status = CoursesStatus.initial,
    this.course,
    this.message,
  });

  final CoursesStatus status;
  final CourseDetailsModel? course;
  final String? message;

  CourseDetailsState copyWith({
    CoursesStatus? status,
    CourseDetailsModel? course,
    String? message,
  }) {
    return CourseDetailsState(
      status: status ?? this.status,
      course: course ?? this.course,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, course, message];
}
