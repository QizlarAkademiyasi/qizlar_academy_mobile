part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class TasksStarted extends TasksEvent {
  const TasksStarted();

  @override
  List<Object?> get props => [];
}

class TasksRefreshRequested extends TasksEvent {
  const TasksRefreshRequested();

  @override
  List<Object?> get props => [];
}
