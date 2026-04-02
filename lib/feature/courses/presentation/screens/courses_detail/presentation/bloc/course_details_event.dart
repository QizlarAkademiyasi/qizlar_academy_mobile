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

/// Quizdan qaytish kabi holatlarda kursni qayta yuklash; status `loading` ga o‘tmaydi.
final class CoursesCourseDetailsBackgroundRefreshRequested extends CourseDetailsEvent {
  const CoursesCourseDetailsBackgroundRefreshRequested({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}

/// Sharh yuborilgandan keyin ro‘yxatga optimistik qo‘shish (server GET dan oldin).
final class CoursesReviewSubmitSucceeded extends CourseDetailsEvent {
  const CoursesReviewSubmitSucceeded({
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  final String courseId;
  final double rating;
  final String comment;

  @override
  List<Object?> get props => [courseId, rating, comment];
}

final class CoursesRetryRequested extends CourseDetailsEvent {
  const CoursesRetryRequested();
}

final class CoursesEnrollRequested extends CourseDetailsEvent {
  const CoursesEnrollRequested({
    required this.courseId,
    this.openLessonPlayerAfterSuccess = true,
    this.lessonIdAfterSuccess,
  });

  final String courseId;
  final bool openLessonPlayerAfterSuccess;
  final String? lessonIdAfterSuccess;

  @override
  List<Object?> get props => [
    courseId,
    openLessonPlayerAfterSuccess,
    lessonIdAfterSuccess,
  ];
}

final class CoursesEnrollErrorCleared extends CourseDetailsEvent {
  const CoursesEnrollErrorCleared();
}

final class CoursesEnrollOpenPlayerConsumed extends CourseDetailsEvent {
  const CoursesEnrollOpenPlayerConsumed();
}
