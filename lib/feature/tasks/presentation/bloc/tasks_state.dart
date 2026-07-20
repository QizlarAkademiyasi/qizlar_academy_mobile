part of 'tasks_bloc.dart';

enum TasksStatus { initial, loading, success, failure }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.balance = 0,
    this.streakCount,
    this.pageNumber = 1,
    this.pageCount = 1,
    this.message,
  });

  final TasksStatus status;
  final List<TaskItemModel> tasks;
  final int balance;
  final int? streakCount;
  final int pageNumber;
  final int pageCount;
  final String? message;

  List<TaskItemModel> get todayTasks => tasks
      .where((task) => task.frequency == TaskFrequency.daily)
      .toList(growable: false);

  List<TaskItemModel> get otherTasks => tasks
      .where((task) => task.frequency != TaskFrequency.daily)
      .toList(growable: false);

  TasksState copyWith({
    TasksStatus? status,
    List<TaskItemModel>? tasks,
    int? balance,
    int? streakCount,
    bool clearStreakCount = false,
    int? pageNumber,
    int? pageCount,
    String? message,
    bool clearMessage = false,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      balance: balance ?? this.balance,
      streakCount: clearStreakCount ? null : (streakCount ?? this.streakCount),
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    balance,
    streakCount,
    pageNumber,
    pageCount,
    message,
  ];
}
