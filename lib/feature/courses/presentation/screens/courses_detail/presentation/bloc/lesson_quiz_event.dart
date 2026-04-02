part of 'lesson_quiz_bloc.dart';

sealed class LessonQuizEvent extends Equatable {
  const LessonQuizEvent();

  @override
  List<Object?> get props => [];
}

final class LessonQuizStarted extends LessonQuizEvent {
  const LessonQuizStarted();
}

final class LessonQuizOptionToggled extends LessonQuizEvent {
  const LessonQuizOptionToggled(this.optionId);

  final String optionId;

  @override
  List<Object?> get props => [optionId];
}

final class LessonQuizPrimaryPressed extends LessonQuizEvent {
  const LessonQuizPrimaryPressed();
}
