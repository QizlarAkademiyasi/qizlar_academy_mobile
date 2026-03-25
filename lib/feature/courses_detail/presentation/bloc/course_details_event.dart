part of 'course_details_bloc.dart';

sealed class CourseDetailsEvent extends Equatable {
  const CourseDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class CoursesCourseDetailsRequested extends CourseDetailsEvent {
  const CoursesCourseDetailsRequested({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}

final class CoursesRetryRequested extends CourseDetailsEvent {
  const CoursesRetryRequested();
}
