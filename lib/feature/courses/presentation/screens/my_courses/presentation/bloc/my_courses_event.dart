part of 'my_courses_bloc.dart';

sealed class MyCoursesEvent extends Equatable {
  const MyCoursesEvent();

  @override
  List<Object?> get props => [];
}

class MyCoursesStarted extends MyCoursesEvent {
  const MyCoursesStarted();
}

class MyCoursesRetryRequested extends MyCoursesEvent {
  const MyCoursesRetryRequested();
}

class MyCoursesLoadMoreRequested extends MyCoursesEvent {
  const MyCoursesLoadMoreRequested();
}

class MyCoursesLoadMoreFailureConsumed extends MyCoursesEvent {
  const MyCoursesLoadMoreFailureConsumed();
}
